import 'package:flutter/material.dart';

/// A reusable gradient card widget for displaying information with an icon, label, and value.
///
/// This widget creates a visually appealing card with:
/// - Customizable gradient background colors
/// - Icon with label and value display
/// - Shadow effect
/// - Rounded corners
///
/// Commonly used for displaying metrics like balance, power, points, etc.
class GradientInfoCard extends StatelessWidget {
  /// The margin around the card
  final EdgeInsets margin;

  /// The padding inside the card (defaults to 20px on all sides)
  final EdgeInsets padding;

  /// Colors for the gradient background (from top-left to bottom-right)
  final List<Color> gradientColors;

  /// Color of the shadow effect
  final Color shadowColor;

  /// Icon to display on the left side of the card
  final IconData icon;

  /// Size of the icon (defaults to 32)
  final double iconSize;

  /// Label text displayed above the value
  final String label;

  /// Main value text to display
  final String value;

  /// Font size for the label text (defaults to 13)
  final double labelFontSize;

  /// Font size for the value text (defaults to 24)
  final double valueFontSize;

  /// Alignment for the content (defaults to start)
  final MainAxisAlignment alignment;

  const GradientInfoCard({
    Key? key,
    this.margin = const EdgeInsets.all(16),
    this.padding = const EdgeInsets.all(20),
    required this.gradientColors,
    required this.shadowColor,
    required this.icon,
    this.iconSize = 32,
    required this.label,
    required this.value,
    this.labelFontSize = 13,
    this.valueFontSize = 24,
    this.alignment = MainAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: iconSize),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
