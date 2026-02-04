import 'package:flutter/material.dart';

class ScanDocumentScreen extends StatelessWidget {
  const ScanDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Document'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.document_scanner_outlined,
              size: 120,
              color: Colors.green,
            ),

            const SizedBox(height: 20),

            const Text(
              'Scan farming reports or prescriptions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            const Text(
              'Example:\nSoil test report, crop prescription, lab results',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () {
                // Camera + OCR logic later
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Using Camera'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () {
                // File picker logic later
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Document'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
