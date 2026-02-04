import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Result'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: const [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 90,
                    color: Colors.red,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Leaf Blight Detected',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Confidence',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: 0.87,
              backgroundColor: Colors.grey.shade300,
              color: Colors.red,
              minHeight: 10,
            ),

            const SizedBox(height: 8),
            const Text('87% confidence'),

            const SizedBox(height: 30),

            const Text(
              'Severity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'High – Immediate treatment recommended',
                style: TextStyle(color: Colors.red),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Recommended Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const BulletPoint(text: 'Remove infected leaves immediately'),
            const BulletPoint(text: 'Avoid overhead watering'),
            const BulletPoint(text: 'Apply fungicide within 24 hours'),

            const SizedBox(height: 30),

            const Text(
              'Suggested Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Organic Fungicide'),
                subtitle: const Text('Effective against leaf blight'),
                trailing: const Text('₹120'),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Marketplace integration later
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Buy Recommended Product'),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
