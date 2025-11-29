import 'package:flutter/material.dart';

/// Simple Waveform Painter
/// Draws a simple waveform visualization
class WaveformPainter extends CustomPainter {
  final double amplitude; // 0.0 to 1.0

  WaveformPainter({required this.amplitude});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF155DFC)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final barWidth = 4.0;
    final spacing = 2.0;
    final bars = (size.width / (barWidth + spacing)).floor();

    for (int i = 0; i < bars; i++) {
      final x = i * (barWidth + spacing);
      final barHeight = (size.height * 0.8 * amplitude * 
          (0.5 + 0.5 * (i % 3) / 2));
      final startY = centerY - barHeight / 2;
      final endY = centerY + barHeight / 2;

      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.amplitude != amplitude;
  }
}

