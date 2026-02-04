import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Plant Image'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image_outlined, size: 120, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Upload a plant image for analysis',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.result);
              },
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose from Gallery'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.result);
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Open Camera'),
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
