import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math' as math;

class CalculatorProvider with ChangeNotifier {
  static const String _historyBox = 'history';
  late Box _historyBoxInstance;
  
  String _expression = '';
  String _result = '0';
  bool _isNewNumber = true;

  CalculatorProvider() {
    _init();
  }

  Future<void> _init() async {
    _historyBoxInstance = await Hive.openBox(_historyBox);
  }

  String get expression => _expression;
  String get result => _result;

  void appendNumber(String number) {
    if (_isNewNumber) {
      _expression = number;
      _isNewNumber = false;
    } else {
      _expression += number;
    }
    _calculate();
    notifyListeners();
  }

  void appendOperator(String operator) {
    if (_expression.isEmpty) return;
    
    final lastChar = _expression[_expression.length - 1];
    if (['+', '-', '×', '÷', '%', '(', '^'].contains(lastChar)) {
      _expression = _expression.substring(0, _expression.length - 1);
    }
    
    _expression += operator;
    _isNewNumber = false;
    _calculate();
    notifyListeners();
  }

  void appendFunction(String function) {
    if (_isNewNumber) {
      _expression = function;
      _isNewNumber = false;
    } else {
      _expression += function;
    }
    notifyListeners();
  }

  void appendConstant(String constant) {
    if (constant == 'π') {
      _expression += math.pi.toString();
    } else if (constant == 'e') {
      _expression += math.e.toString();
    }
    _calculate();
    notifyListeners();
  }

  void appendDecimal() {
    if (_isNewNumber) {
      _expression = '0.';
      _isNewNumber = false;
    } else if (!_expression.contains('.')) {
      _expression += '.';
    }
    notifyListeners();
  }

  void clear() {
    _expression = '';
    _result = '0';
    _isNewNumber = true;
    notifyListeners();
  }

  void backspace() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _calculate();
    }
    notifyListeners();
  }

  void toggleSign() {
    if (_expression.isNotEmpty) {
      if (_expression.startsWith('-')) {
        _expression = _expression.substring(1);
      } else {
        _expression = '-$_expression';
      }
      _calculate();
    }
    notifyListeners();
  }

  void calculate() {
    if (_expression.isEmpty) return;
    
    try {
      final parser = Parser();
      final exp = parser.parse(_expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '%')
          .replaceAll('π', math.pi.toString())
          .replaceAll('e', math.e.toString())
          .replaceAll('sin', 'sin')
          .replaceAll('cos', 'cos')
          .replaceAll('tan', 'tan')
          .replaceAll('log', 'log')
          .replaceAll('ln', 'ln')
          .replaceAll('√', 'sqrt'));
      
      final context = ContextModel()
        ..bindVariableName('pi', Number(math.pi))
        ..bindVariableName('e', Number(math.e));
      
      final eval = exp.evaluate(EvaluationType.REAL, context);
      
      _result = eval.toString();
      _saveToHistory();
    } catch (e) {
      _result = 'Error';
    }
    
    _isNewNumber = true;
    notifyListeners();
  }

  void _calculate() {
    if (_expression.isEmpty) {
      _result = '0';
      return;
    }
    
    try {
      final parser = Parser();
      final exp = parser.parse(_expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '%')
          .replaceAll('π', math.pi.toString())
          .replaceAll('e', math.e.toString())
          .replaceAll('sin', 'sin')
          .replaceAll('cos', 'cos')
          .replaceAll('tan', 'tan')
          .replaceAll('log', 'log')
          .replaceAll('ln', 'ln')
          .replaceAll('√', 'sqrt'));
      
      final context = ContextModel()
        ..bindVariableName('pi', Number(math.pi))
        ..bindVariableName('e', Number(math.e));
      
      final eval = exp.evaluate(EvaluationType.REAL, context);
      
      _result = eval.toString();
    } catch (e) {
      _result = '0';
    }
  }

  Future<void> _saveToHistory() async {
    if (_result == 'Error') return;
    
    final historyItem = {
      'expression': _expression,
      'result': _result,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await _historyBoxInstance.add(historyItem);
  }
} 