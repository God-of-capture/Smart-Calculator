import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_calculator/providers/unit_converter_provider.dart';

class UnitConverterScreen extends StatelessWidget {
  const UnitConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UnitConverterProvider>(
      builder: (context, converter, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButton<ConversionType>(
                value: converter.selectedType,
                items: ConversionType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (type) {
                  if (type != null) {
                    converter.setConversionType(type);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: converter.inputController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Input Value',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  converter.convert(value);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: converter.fromUnit,
                      items: converter.availableUnits.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (unit) {
                        if (unit != null) {
                          converter.setFromUnit(unit);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<String>(
                      value: converter.toUnit,
                      items: converter.availableUnits.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (unit) {
                        if (unit != null) {
                          converter.setToUnit(unit);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Result:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        converter.result,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 