import 'package:flutter/material.dart';
import 'marketplace_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Dashboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Farm Health',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              height: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 82,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Expanded(flex: 12, child: Container(color: Colors.yellow)),
                  Expanded(flex: 6, child: Container(color: Colors.red)),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              'Healthy 82%  •  At Risk 12%  •  Diseased 6%',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            const Text(
              'Marketplace Suggestions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Organic Fungicide'),
                subtitle: const Text('Recommended for leaf diseases'),
                trailing: const Text('₹120'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MarketplaceScreen(),
                    ),
                  );
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Nitrogen Fertilizer'),
                subtitle: const Text('Improves crop health'),
                trailing: const Text('₹200'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MarketplaceScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
