// core/widgets/logo.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that displays the Ikigugu logo.
/// 
/// This widget renders the Ikigugu logo using an SVG asset and optionally
/// displays the company name below it. The logo can be customized in size
/// and whether to show the text label.
class IkiguguLogo extends StatelessWidget {
  /// The size of the logo in logical pixels.
  /// 
  /// This value determines both the width and height of the logo image,
  /// maintaining a square aspect ratio. Defaults to 120 logical pixels.
  final double size;

  /// Whether to display the "IKIGUGU" text below the logo.
  /// 
  /// When true, displays the company name below the logo image using
  /// the app's primary color. Defaults to true.
  final bool withText;
  
  const IkiguguLogo({
    super.key,
    this.size = 120,
    this.withText = true,
  });

  /// Builds the logo widget with optional text label.
  /// 
  /// Creates a column containing the SVG logo and, if [withText] is true,
  /// adds the "IKIGUGU" text below it with appropriate styling and spacing.
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