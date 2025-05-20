// features/loyalty/presentation/screens/loyalty_screen.dart
import 'package:flutter/material.dart';

class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({super.key});

  @override
  State<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  int points = 1250;
  List<Map<String, dynamic>> nfts = [
    {'id': 1, 'name': 'Golden Puff', 'image': 'assets/nfts/golden.png', 'owned': true},
    {'id': 2, 'name': 'Spicy Legend', 'image': 'assets/nfts/spicy.png', 'owned': false},
    {'id': 3, 'name': 'Cheese Master', 'image': 'assets/nfts/cheese.png', 'owned': true},
    {'id': 4, 'name': 'Veggie King', 'image': 'assets/nfts/veggie.png', 'owned': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puff Loyalty NFTs'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Your Puff Points',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    points.toString(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: points / 2000,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${((points / 2000) * 100).toStringAsFixed(1)}% to next NFT',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: nfts.length,
              itemBuilder: (context, index) {
                final nft = nfts[index];
                return Card(
                  color: nft['owned']
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceVariant,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(nft['image']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(nft['name']),
                            const SizedBox(height: 4),
                            nft['owned']
                                ? const Chip(
                                    label: Text('OWNED'),
                                    backgroundColor: Colors.green,
                                  )
                                : const Chip(
                                    label: Text('2000 PTS'),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}