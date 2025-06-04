// features/puff_sommelier/presentation/screens/sommelier_screen.dart
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// A screen that uses AI to recommend drinks that pair well with a specific curry puff.
/// Uses TensorFlow Lite to process the puff ID and generate drink recommendations.
class SommelierScreen extends StatefulWidget {
  /// The unique identifier of the curry puff for which to get drink recommendations.
  final int puffId;

  /// Creates a new [SommelierScreen] instance.
  /// 
  /// Requires [puffId] to identify which curry puff to analyze.
  const SommelierScreen({
    required this.puffId,
    super.key,
  });

  @override
  State<SommelierScreen> createState() => _SommelierScreenState();
}

class _SommelierScreenState extends State<SommelierScreen> {
  Interpreter? _interpreter;
  List<String> recommendations = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/puff_sommelier.tflite');
      await _getRecommendations();
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Failed to load AI model: ${e.toString()}';
      });
    }
  }

  Future<void> _getRecommendations() async {
    try {
      if (_interpreter == null) {
        throw Exception('Model not loaded');
      }

      // Input shape: [1, 1] - just the puff ID
      final input = [
        [widget.puffId.toDouble()]
      ];

      // Output shape: [1, 4] - top 4 drink recommendations
      final List<double> outputBuffer = List.filled(1 * 4, 0.0);
      final output = outputBuffer.reshape<double>([1, 4]);

      // Run inference
      _interpreter!.run(input, output);

      // Convert output to drink recommendations
      // In a real app, you'd have a mapping of indices to drink names
      final drinkNames = [
        'Iced Lemon Tea',
        'Hot Masala Chai',
        'Cold Brew Coffee',
        'Sparkling Water with Lime',
        'Green Tea',
        'Mango Lassi',
        'Ginger Beer',
        'Rose Milk Tea'
      ];

      // Get top 4 recommendations based on model output
      final List<double> scores = List<double>.from(output[0]);
      final recommendations = List.generate(4, (i) {
        final maxIndex = scores.indexWhere((score) => score == scores.reduce((double a, double b) => a > b ? a : b));
        scores[maxIndex] = -1; // Mark as used
        return drinkNames[maxIndex % drinkNames.length];
      });

      setState(() {
        isLoading = false;
        this.recommendations = recommendations;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Error getting recommendations: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puff Sommelier'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          error!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              error = null;
                            });
                            _loadModel();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.local_drink),
                        title: Text(recommendations[index]),
                        subtitle: Text('Perfect match for your puff #${widget.puffId}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    );
                  },
                ),
    );
  }
}