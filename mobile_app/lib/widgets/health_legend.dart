import 'package:flutter/material.dart';

class HealthLegend extends StatelessWidget {
  const HealthLegend({super.key});

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _legendItem(Colors.green, 'Healthy'),
        _legendItem(Colors.yellow, 'At Risk'),
        _legendItem(Colors.red, 'Diseased'),
      ],
    );
  }
}
