import 'package:flutter/material.dart';
import '../widgets/action_button.dart';
import '../widgets/farm_grid.dart';
import '../widgets/health_legend.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Farming'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Farming',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  icon: Icons.camera_alt,
                  label: 'Upload Image',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.upload);
                  },
                ),
                ActionButton(
                  icon: Icons.mic,
                  label: 'Voice Input',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.voice);
                  },
                ),
                ActionButton(
                  icon: Icons.document_scanner,
                  label: 'Scan Doc',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.scan);
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.dashboard);
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 270,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Farm Visualization',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Expanded(child: FarmGrid()),
                        SizedBox(height: 12),
                        HealthLegend(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
