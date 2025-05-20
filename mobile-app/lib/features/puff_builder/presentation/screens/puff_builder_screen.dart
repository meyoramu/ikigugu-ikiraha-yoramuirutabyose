// features/puff_builder/presentation/screens/puff_builder_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_rive/flutter_rive.dart';

class PuffBuilderScreen extends StatefulWidget {
  const PuffBuilderScreen({super.key});

  @override
  State<PuffBuilderScreen> createState() => _PuffBuilderScreenState();
}

class _PuffBuilderScreenState extends State<PuffBuilderScreen> {
  List<String> selectedIngredients = [];
  final List<String> availableIngredients = [
    'Chicken', 'Potato', 'Curry Sauce', 'Egg', 
    'Mushroom', 'Cheese', 'Spicy', 'Vegetables'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Your Puff'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                return Center(
                  child: RiveAnimation.asset(
                    'assets/animations/puff_base.riv',
                    stateMachines: ['State Machine'],
                    artboard: 'PuffBuilder',
                  ),
                );
              },
              onAccept: (data) {
                setState(() {
                  if (!selectedIngredients.contains(data)) {
                    selectedIngredients.add(data);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: availableIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = availableIngredients[index];
                return LongPressDraggable<String>(
                  data: ingredient,
                  feedback: Material(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(ingredient),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Text(ingredient)),
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