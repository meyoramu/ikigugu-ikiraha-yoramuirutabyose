// core/widgets/logo.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IkiguguLogo extends StatelessWidget {
  final double size;
  final bool withText;
  
  const IkiguguLogo({
    super.key,
    this.size = 120,
    this.withText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/logo.svg',
          width: size,
          height: size,
        ),
        if (withText) ...[
          const SizedBox(height: 8),
          Text(
            'IKIGUGU',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
        ],
      ],
    );
  }
}