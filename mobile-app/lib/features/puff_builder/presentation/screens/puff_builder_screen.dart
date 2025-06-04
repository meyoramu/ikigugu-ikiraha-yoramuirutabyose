// features/puff_builder/presentation/screens/puff_builder_screen.dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

/// An interactive screen that allows users to customize their curry puff.
/// 
/// This screen provides a drag-and-drop interface where users can:
/// * View a dynamic Rive animation of their curry puff
/// * Drag ingredients onto the puff to add them
/// * See available ingredients in a grid layout
/// * Customize their puff with various fillings and toppings
class PuffBuilderScreen extends StatefulWidget {
  /// Creates a screen for building custom curry puffs.
  /// 
  /// This screen uses Rive animations to provide an interactive
  /// and visually appealing curry puff customization experience.
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
                  child: rive.RiveAnimation.asset(
                    'assets/animations/puff_base.riv',
                    stateMachines: const ['State Machine'],
                    artboard: 'PuffBuilder',
                  ),
                );
              },
              onAcceptWithDetails: (details) {
                setState(() {
                  if (!selectedIngredients.contains(details.data)) {
                    selectedIngredients.add(details.data);
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
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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