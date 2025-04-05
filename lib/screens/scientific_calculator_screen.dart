import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_calculator/providers/calculator_provider.dart';

class ScientificCalculatorScreen extends StatelessWidget {
  const ScientificCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, calculator, child) {
        return Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      calculator.expression,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      calculator.result,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: GridView.count(
                crossAxisCount: 5,
                padding: const EdgeInsets.all(8),
                children: [
                  _buildButton('sin', () => calculator.appendFunction('sin(')),
                  _buildButton('cos', () => calculator.appendFunction('cos(')),
                  _buildButton('tan', () => calculator.appendFunction('tan(')),
                  _buildButton('log', () => calculator.appendFunction('log(')),
                  _buildButton('ln', () => calculator.appendFunction('ln(')),
                  _buildButton('π', () => calculator.appendConstant('π')),
                  _buildButton('e', () => calculator.appendConstant('e')),
                  _buildButton('(', () => calculator.appendOperator('(')),
                  _buildButton(')', () => calculator.appendOperator(')')),
                  _buildButton('C', calculator.clear),
                  _buildButton('7', () => calculator.appendNumber('7')),
                  _buildButton('8', () => calculator.appendNumber('8')),
                  _buildButton('9', () => calculator.appendNumber('9')),
                  _buildButton('÷', () => calculator.appendOperator('÷')),
                  _buildButton('⌫', calculator.backspace),
                  _buildButton('4', () => calculator.appendNumber('4')),
                  _buildButton('5', () => calculator.appendNumber('5')),
                  _buildButton('6', () => calculator.appendNumber('6')),
                  _buildButton('×', () => calculator.appendOperator('×')),
                  _buildButton('x²', () => calculator.appendFunction('^2')),
                  _buildButton('1', () => calculator.appendNumber('1')),
                  _buildButton('2', () => calculator.appendNumber('2')),
                  _buildButton('3', () => calculator.appendNumber('3')),
                  _buildButton('-', () => calculator.appendOperator('-')),
                  _buildButton('√', () => calculator.appendFunction('√(')),
                  _buildButton('0', () => calculator.appendNumber('0')),
                  _buildButton('.', () => calculator.appendDecimal()),
                  _buildButton('±', calculator.toggleSign),
                  _buildButton('+', () => calculator.appendOperator('+')),
                  _buildButton('=', calculator.calculate),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
} 