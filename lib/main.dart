import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_calculator/providers/theme_provider.dart';
import 'package:smart_calculator/providers/calculator_provider.dart';
import 'package:smart_calculator/providers/unit_converter_provider.dart';
import 'package:smart_calculator/providers/currency_converter_provider.dart';
import 'package:smart_calculator/providers/scanner_provider.dart';
import 'package:smart_calculator/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register Hive adapters
  await Hive.openBox('settings');
  await Hive.openBox('history');
  await Hive.openBox('conversion_history');
  await Hive.openBox('currency_rates');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => UnitConverterProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyConverterProvider()),
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Smart Calculator',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
} 