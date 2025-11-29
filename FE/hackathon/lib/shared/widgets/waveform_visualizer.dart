import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Waveform Visualizer Widget
/// Displays audio waveform visualization with live status
class WaveformVisualizer extends StatelessWidget {
  final bool isLive;
  final Widget? waveformContent;

  const WaveformVisualizer({
    super.key,
    this.isLive = true,
    this.waveformContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEFF6FF),
            Color(0xFFDBEAFE),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFBEDBFF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Audio Monitor',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (isLive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                  child: Text(
                    'Live',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF008236),
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Canvas Area
          Container(
            width: double.infinity,
            height: 107.25,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16.4),
            ),
            clipBehavior: Clip.antiAlias,
            child: waveformContent ??
                Center(
                  child: Text(
                    'Waveform visualization',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

