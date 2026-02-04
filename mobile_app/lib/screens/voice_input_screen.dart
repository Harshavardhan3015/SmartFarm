import 'package:flutter/material.dart';

class VoiceInputScreen extends StatelessWidget {
  const VoiceInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Assistant'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mic,
              size: 120,
              color: Colors.green,
            ),

            const SizedBox(height: 20),

            const Text(
              'Speak your farming query',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            const Text(
              'Example:\n"Why are my tomato leaves turning yellow?"',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                // Voice recognition logic later
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24),
              ),
              child: const Icon(
                Icons.mic,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Tap to start listening',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
