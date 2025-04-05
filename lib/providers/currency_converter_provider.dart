import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverterProvider with ChangeNotifier {
  static const String _ratesBox = 'currency_rates';
  static const String _apiKey = '61cd753f55d4430fb891e6926a1432a3';
  static const String _baseUrl = 'https://api.exchangerate.host';
  
  late Box _ratesBoxInstance;
  final TextEditingController inputController = TextEditingController();
  
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  String _result = '0';
  String _lastUpdated = 'Never';
  Map<String, double> _rates = {};
  
  final List<String> _availableCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'CHF', 'CNY', 'INR', 'BRL',
  ];

  CurrencyConverterProvider() {
    _init();
  }

  Future<void> _init() async {
    _ratesBoxInstance = await Hive.openBox(_ratesBox);
    await _loadRates();
  }

  String get fromCurrency => _fromCurrency;
  String get toCurrency => _toCurrency;
  String get result => _result;
  String get lastUpdated => _lastUpdated;
  List<String> get availableCurrencies => _availableCurrencies;

  void setFromCurrency(String currency) {
    _fromCurrency = currency;
    convert(inputController.text);
    notifyListeners();
  }

  void setToCurrency(String currency) {
    _toCurrency = currency;
    convert(inputController.text);
    notifyListeners();
  }

  Future<void> refreshRates() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/latest?base=$_fromCurrency&symbols=${_availableCurrencies.join(',')}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _rates = Map<String, double>.from(data['rates']);
        _lastUpdated = DateTime.now().toString();
        
        await _saveRates();
        convert(inputController.text);
      }
    } catch (e) {
      // If API call fails, use cached rates
      await _loadRates();
    }
  }

  Future<void> _loadRates() async {
    final cachedRates = _ratesBoxInstance.get('rates');
    final cachedDate = _ratesBoxInstance.get('lastUpdated');
    
    if (cachedRates != null && cachedDate != null) {
      _rates = Map<String, double>.from(cachedRates);
      _lastUpdated = cachedDate;
    } else {
      await refreshRates();
    }
  }

  Future<void> _saveRates() async {
    await _ratesBoxInstance.put('rates', _rates);
    await _ratesBoxInstance.put('lastUpdated', _lastUpdated);
  }

  void convert(String value) {
    if (value.isEmpty) {
      _result = '0';
      notifyListeners();
      return;
    }

    try {
      final amount = double.parse(value);
      if (_rates.isEmpty) {
        _result = 'Loading rates...';
        refreshRates();
        return;
      }

      if (_fromCurrency == _toCurrency) {
        _result = amount.toStringAsFixed(2);
      } else {
        final fromRate = _rates[_fromCurrency] ?? 1.0;
        final toRate = _rates[_toCurrency] ?? 1.0;
        final convertedAmount = (amount / fromRate) * toRate;
        _result = convertedAmount.toStringAsFixed(2);
      }
    } catch (e) {
      _result = 'Error';
    }

    notifyListeners();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
} 