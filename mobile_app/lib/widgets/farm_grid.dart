import 'package:flutter/material.dart';

class FarmGrid extends StatelessWidget {
  const FarmGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary static data (UI only)
    final List<Color> farmStatus = [
      Colors.green,
      Colors.green,
      Colors.yellow,
      Colors.green,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.green,
      Colors.green,
      Colors.red,
      Colors.green,
      Colors.green,
    ];

    return GridView.builder(
      itemCount: farmStatus.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: farmStatus[index],
            borderRadius: BorderRadius.circular(6),
          ),
        );
      },
    );
  }
}
