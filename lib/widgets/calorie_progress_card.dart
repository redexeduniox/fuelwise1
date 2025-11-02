import 'package:flutter/material.dart';
import 'dart:math' as math;

class CalorieProgressCard extends StatelessWidget {
  final int totalCalories;
  final int goalCalories;

  const CalorieProgressCard({
    super.key,
    required this.totalCalories,
    required this.goalCalories,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goalCalories > 0
        ? (totalCalories / goalCalories).clamp(0.0, 1.0)
        : 0.0;
    final remaining = math.max(goalCalories - totalCalories, 0);
    final over = math.max(totalCalories - goalCalories, 0);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: CircularProgressPainter(progress: progress),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$totalCalories', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('of $goalCalories cal', style: const TextStyle(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem('Consumed', '$totalCalories', const Color(0xFF00D9A5)),
              Container(width: 1, height: 40, color: Colors.white24),
              if (over == 0)
                _buildInfoItem('Remaining', '$remaining', const Color(0xFFFFA726))
              else
                _buildInfoItem('Over', '$over', const Color(0xFFFF6B9D)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.white70)),
      ],
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;

  CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final backgroundPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius - 6, backgroundPaint);
    
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00D9A5), Color(0xFF00F5B8)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) => oldDelegate.progress != progress;
}
