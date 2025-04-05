import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum ConversionType {
  length('Length'),
  weight('Weight'),
  temperature('Temperature'),
  area('Area'),
  volume('Volume'),
  time('Time');

  final String name;
  const ConversionType(this.name);
}

class UnitConverterProvider with ChangeNotifier {
  static const String _historyBox = 'conversion_history';
  late Box _historyBoxInstance;
  
  final TextEditingController inputController = TextEditingController();
  ConversionType _selectedType = ConversionType.length;
  String _fromUnit = 'Meter';
  String _toUnit = 'Kilometer';
  String _result = '0';
  
  final Map<ConversionType, List<String>> _units = {
    ConversionType.length: ['Meter', 'Kilometer', 'Centimeter', 'Millimeter', 'Inch', 'Foot', 'Yard', 'Mile'],
    ConversionType.weight: ['Gram', 'Kilogram', 'Milligram', 'Pound', 'Ounce', 'Ton'],
    ConversionType.temperature: ['Celsius', 'Fahrenheit', 'Kelvin'],
    ConversionType.area: ['Square Meter', 'Square Kilometer', 'Square Foot', 'Square Inch', 'Acre', 'Hectare'],
    ConversionType.volume: ['Liter', 'Milliliter', 'Cubic Meter', 'Gallon', 'Quart', 'Pint', 'Cup'],
    ConversionType.time: ['Second', 'Minute', 'Hour', 'Day', 'Week', 'Month', 'Year'],
  };

  UnitConverterProvider() {
    _init();
  }

  Future<void> _init() async {
    _historyBoxInstance = await Hive.openBox(_historyBox);
  }

  ConversionType get selectedType => _selectedType;
  String get fromUnit => _fromUnit;
  String get toUnit => _toUnit;
  String get result => _result;
  List<String> get availableUnits => _units[_selectedType] ?? [];

  void setConversionType(ConversionType type) {
    _selectedType = type;
    _fromUnit = _units[type]?.first ?? '';
    _toUnit = _units[type]?.elementAt(1) ?? '';
    convert(inputController.text);
    notifyListeners();
  }

  void setFromUnit(String unit) {
    _fromUnit = unit;
    convert(inputController.text);
    notifyListeners();
  }

  void setToUnit(String unit) {
    _toUnit = unit;
    convert(inputController.text);
    notifyListeners();
  }

  void convert(String value) {
    if (value.isEmpty) {
      _result = '0';
      notifyListeners();
      return;
    }

    try {
      final input = double.parse(value);
      double convertedValue = 0;

      switch (_selectedType) {
        case ConversionType.length:
          convertedValue = _convertLength(input);
          break;
        case ConversionType.weight:
          convertedValue = _convertWeight(input);
          break;
        case ConversionType.temperature:
          convertedValue = _convertTemperature(input);
          break;
        case ConversionType.area:
          convertedValue = _convertArea(input);
          break;
        case ConversionType.volume:
          convertedValue = _convertVolume(input);
          break;
        case ConversionType.time:
          convertedValue = _convertTime(input);
          break;
      }

      _result = convertedValue.toStringAsFixed(6);
      _saveToHistory(input, convertedValue);
    } catch (e) {
      _result = 'Error';
    }

    notifyListeners();
  }

  double _convertLength(double value) {
    // Convert to meters first
    double inMeters = value;
    switch (_fromUnit) {
      case 'Kilometer':
        inMeters = value * 1000;
        break;
      case 'Centimeter':
        inMeters = value / 100;
        break;
      case 'Millimeter':
        inMeters = value / 1000;
        break;
      case 'Inch':
        inMeters = value * 0.0254;
        break;
      case 'Foot':
        inMeters = value * 0.3048;
        break;
      case 'Yard':
        inMeters = value * 0.9144;
        break;
      case 'Mile':
        inMeters = value * 1609.344;
        break;
    }

    // Convert to target unit
    switch (_toUnit) {
      case 'Kilometer':
        return inMeters / 1000;
      case 'Centimeter':
        return inMeters * 100;
      case 'Millimeter':
        return inMeters * 1000;
      case 'Inch':
        return inMeters / 0.0254;
      case 'Foot':
        return inMeters / 0.3048;
      case 'Yard':
        return inMeters / 0.9144;
      case 'Mile':
        return inMeters / 1609.344;
      default:
        return inMeters;
    }
  }

  double _convertWeight(double value) {
    // Convert to grams first
    double inGrams = value;
    switch (_fromUnit) {
      case 'Kilogram':
        inGrams = value * 1000;
        break;
      case 'Milligram':
        inGrams = value / 1000;
        break;
      case 'Pound':
        inGrams = value * 453.59237;
        break;
      case 'Ounce':
        inGrams = value * 28.349523125;
        break;
      case 'Ton':
        inGrams = value * 1000000;
        break;
    }

    // Convert to target unit
    switch (_toUnit) {
      case 'Kilogram':
        return inGrams / 1000;
      case 'Milligram':
        return inGrams * 1000;
      case 'Pound':
        return inGrams / 453.59237;
      case 'Ounce':
        return inGrams / 28.349523125;
      case 'Ton':
        return inGrams / 1000000;
      default:
        return inGrams;
    }
  }

  double _convertTemperature(double value) {
    // Convert to Celsius first
    double inCelsius = value;
    switch (_fromUnit) {
      case 'Fahrenheit':
        inCelsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        inCelsius = value - 273.15;
        break;
    }

    // Convert to target unit
    switch (_toUnit) {
      case 'Fahrenheit':
        return (inCelsius * 9 / 5) + 32;
      case 'Kelvin':
        return inCelsius + 273.15;
      default:
        return inCelsius;
    }
  }

  double _convertArea(double value) {
    // Convert to square meters first
    double inSquareMeters = value;
    switch (_fromUnit) {
      case 'Square Kilometer':
        inSquareMeters = value * 1000000;
        break;
      case 'Square Foot':
        inSquareMeters = value * 0.092903;
        break;
      case 'Square Inch':
        inSquareMeters = value * 0.00064516;
        break;
      case 'Acre':
        inSquareMeters = value * 4046.86;
        break;
      case 'Hectare':
        inSquareMeters = value * 10000;
        break;
    }

    // Convert to target unit
    switch (_toUnit) {
      case 'Square Kilometer':
        return inSquareMeters / 1000000;
      case 'Square Foot':
        return inSquareMeters / 0.092903;
      case 'Square Inch':
        return inSquareMeters / 0.00064516;
      case 'Acre':
        return inSquareMeters / 4046.86;
      case 'Hectare':
        return inSquareMeters / 10000;
      default:
        return inSquareMeters;
    }
  }

  double _convertVolume(double value) {
    // Convert to liters first
    double inLiters = value;
    switch (_fromUnit) {
      case 'Milliliter':
        inLiters = value / 1000;
        break;
      case 'Cubic Meter':
        inLiters = value * 1000;
        break;
      case 'Gallon':
        inLiters = value * 3.78541;
        break;
      case 'Quart':
        inLiters = value * 0.946353;
        break;
      case 'Pint':
        inLiters = value * 0.473176;
        break;
      case 'Cup':
        inLiters = value * 0.236588;
        break;
    }

    // Convert to target unit
    switch (_toUnit) {
      case 'Milliliter':
        return inLiters * 1000;
      case 'Cubic Meter':
        return inLiters / 1000;
      case 'Gallon':
        return inLiters / 3.78541;
      case 'Quart':
        return inLiters / 0.946353;
      case 'Pint':
        return inLiters / 0.473176;
      case 'Cup':
        return inLiters / 0.236588;
      default:
        return inLiters;
    }
  }

  double _convertTime(double value) {
    // Convert to seconds first
    double inSeconds = value;
    switch (_fromUnit) {
      case 'Minute':
        inSeconds = value * 60;
        break;
      case 'Hour':
        inSeconds = value * 3600;
        break;
      case 'Day':
        inSeconds = value * 86400;
        break;
      case 'Week':
        inSeconds = value * 604800;
        break;
      case 'Month':
        inSeconds = value * 2629746;
        break;
      case 'Year':
        inSeconds = value * 31556952;
        break;
    }

    // Convert to target unit
    switch (_toUnit) {
      case 'Minute':
        return inSeconds / 60;
      case 'Hour':
        return inSeconds / 3600;
      case 'Day':
        return inSeconds / 86400;
      case 'Week':
        return inSeconds / 604800;
      case 'Month':
        return inSeconds / 2629746;
      case 'Year':
        return inSeconds / 31556952;
      default:
        return inSeconds;
    }
  }

  Future<void> _saveToHistory(double input, double output) async {
    final historyItem = {
      'type': _selectedType.name,
      'fromUnit': _fromUnit,
      'toUnit': _toUnit,
      'input': input,
      'output': output,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await _historyBoxInstance.add(historyItem);
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
} 