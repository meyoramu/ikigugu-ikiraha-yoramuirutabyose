// features/puff_sommelier/presentation/screens/sommelier_screen.dart
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class SommelierScreen extends StatefulWidget {
  final int puffId;

  const SommelierScreen({super.key, required this.puffId});

  @override
  State<SommelierScreen> createState() => _SommelierScreenState();
}

class _SommelierScreenState extends State<SommelierScreen> {
  late Interpreter _interpreter;
  List<String> recommendations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('models/puff_sommelier.tflite');
      _getRecommendations();
    } catch (e) {
      setState(() {
        isLoading = false;
        recommendations = ['Could not load recommendations'];
      });
    }
  }

  void _getRecommendations() {
    // Mock AI processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        recommendations = [
          'Iced Lemon Tea',
          'Hot Masala Chai',
          'Cold Brew Coffee',
          'Sparkling Water with Lime'
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puff Sommelier'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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