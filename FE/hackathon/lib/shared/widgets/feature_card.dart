import 'package:flutter/material.dart';

/// Feature Card Widget
/// Displays a feature with icon, title, and description
class FeatureCard extends StatelessWidget {
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Widget icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.backgroundColor,
    required this.iconBackgroundColor,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(16.4),
            ),
            child: Center(child: icon),
          ),
          const SizedBox(width: 12),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 4),
                // Description
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4A5565),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
