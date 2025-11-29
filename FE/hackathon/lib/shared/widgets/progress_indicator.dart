import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Step Progress Indicator Widget
/// Shows step progress (e.g., "Step 1 / 3" and progress bar)
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double progress; // 0.0 to 1.0

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $currentStep / $totalSteps',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            Text(
              '$percentage%',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Progress Bar
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(16777200), // Fully rounded
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(16777200),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
