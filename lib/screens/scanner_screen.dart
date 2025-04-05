import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:smart_calculator/providers/scanner_provider.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (context, scanner, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (scanner.imagePath != null)
                Expanded(
                  child: Image.file(
                    scanner.imagePath!,
                    fit: BoxFit.contain,
                  ),
                )
              else
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('No image selected'),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: scanner.pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
                  ),
                  ElevatedButton.icon(
                    onPressed: scanner.scanImage,
                    icon: const Icon(Icons.scanner),
                    label: const Text('Scan'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (scanner.scannedText.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scanned Text:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(scanner.scannedText),
                        const SizedBox(height: 16),
                        Text(
                          'Result:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          scanner.result,
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