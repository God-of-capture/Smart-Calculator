# Smart Calculator

A full-featured, offline-first mobile calculator app built with Flutter and Dart.

## Features

- **Basic Calculator**: Standard arithmetic operations with real-time calculation
- **Scientific Calculator**: Advanced mathematical functions and constants
- **Unit Converter**: Convert between various units of measurement
  - Length (meter, kilometer, inch, foot, etc.)
  - Weight (gram, kilogram, pound, ounce, etc.)
  - Temperature (Celsius, Fahrenheit, Kelvin)
  - Area (square meter, square foot, acre, etc.)
  - Volume (liter, gallon, quart, etc.)
  - Time (second, minute, hour, etc.)
- **Currency Converter**: Real-time currency conversion with offline support
- **OCR Scanner**: Scan and solve math problems using Google ML Kit
- **Dark Mode**: Toggle between light and dark themes
- **History**: Save and view calculation history
- **Offline Support**: Work without internet connection (except for currency rates)

## Setup

1. Clone the repository
2. Install Flutter and Dart SDK
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Update the API key in `lib/providers/currency_converter_provider.dart`
5. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- `provider`: State management
- `hive`: Local storage
- `math_expressions`: Mathematical expression parsing and evaluation
- `google_ml_kit`: OCR functionality
- `http`: API calls for currency rates
- `image_picker`: Image selection for OCR
- `speech_to_text`: Voice input support

## Project Structure

```
lib/
├── main.dart
├── providers/
│   ├── calculator_provider.dart
│   ├── currency_converter_provider.dart
│   ├── scanner_provider.dart
│   ├── theme_provider.dart
│   └── unit_converter_provider.dart
└── screens/
    ├── basic_calculator_screen.dart
    ├── currency_converter_screen.dart
    ├── home_screen.dart
    ├── scientific_calculator_screen.dart
    ├── scanner_screen.dart
    └── unit_converter_screen.dart
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 