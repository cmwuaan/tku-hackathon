import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Status Badge Widget
/// Shows status with colored dot and text
class StatusBadge extends StatelessWidget {
  final Color dotColor;
  final String text;
  final Color textColor;

  const StatusBadge({
    super.key,
    required this.dotColor,
    required this.text,
    this.textColor = AppTheme.textTertiary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
        ),
      ],
    );
  }
}

