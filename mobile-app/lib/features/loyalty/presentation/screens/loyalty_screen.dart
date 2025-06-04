// features/loyalty/presentation/screens/loyalty_screen.dart
import 'package:flutter/material.dart';

/// A model class to represent an NFT in the loyalty program
class LoyaltyNFT {
  /// Unique identifier for the NFT
  final int id;

  /// Display name of the NFT
  final String name;

  /// Asset path to the NFT's image file
  final String imagePath;

  /// Whether the user owns this NFT
  final bool owned;

  /// Creates a new [LoyaltyNFT] instance.
  /// 
  /// All parameters are required:
  /// - [id]: Unique identifier for the NFT
  /// - [name]: Display name of the NFT
  /// - [imagePath]: Asset path to the NFT's image file
  /// - [owned]: Whether the user owns this NFT
  const LoyaltyNFT({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.owned,
  });
}

/// Screen that displays the user's loyalty program status and NFT collection.
/// Shows the current points balance and available/owned NFTs.
class LoyaltyScreen extends StatefulWidget {
  /// Creates a loyalty screen widget.
  const LoyaltyScreen({super.key});

  @override
  State<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  final int points = 1250;
  final List<LoyaltyNFT> nfts = [
    LoyaltyNFT(id: 1, name: 'Golden Puff', imagePath: 'assets/nfts/golden.png', owned: true),
    LoyaltyNFT(id: 2, name: 'Spicy Legend', imagePath: 'assets/nfts/spicy.png', owned: false),
    LoyaltyNFT(id: 3, name: 'Cheese Master', imagePath: 'assets/nfts/cheese.png', owned: true),
    LoyaltyNFT(id: 4, name: 'Veggie King', imagePath: 'assets/nfts/veggie.png', owned: false),
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
                  color: nft.owned
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(nft.imagePath),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(nft.name),
                            const SizedBox(height: 4),
                            nft.owned
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