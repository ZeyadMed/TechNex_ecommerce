import 'package:flutter/material.dart';
import 'package:e_commerce/core/theme/app_colors.dart';

/// A segmented circular page indicator that draws a ring divided into [itemCount]
/// segments and highlights the active segment. A filled center circle contains
/// a chevron icon like in the design.
class SegmentedCircularIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final double size;
  final double strokeWidth;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback? onTap;

  SegmentedCircularIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    this.size = 30.0,
    this.strokeWidth = 8.0,
    Color? activeColor,
    this.inactiveColor = const Color(0xFFF0EDE8),
    this.onTap,
  }) : activeColor = activeColor ?? AppColors.primaryColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _SegmentedRingPainter(
              activeIndex: currentIndex,
              segments: itemCount,
              strokeWidth: strokeWidth,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ),
          // center circle with chevron (pointing left for RTL look)
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: size * 0.50,
              width: size * 0.50,
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withOpacity(0.14),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: size * 0.28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedRingPainter extends CustomPainter {
  final int segments;
  final int activeIndex;
  final double strokeWidth;
  final Color activeColor;
  final Color inactiveColor;

  _SegmentedRingPainter({
    required this.segments,
    required this.activeIndex,
    required this.strokeWidth,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final double gapAngle = radians(8); // small gap between segments
    final double sweep = (2 * 3.141592653589793) / segments;

    for (int i = 0; i < segments; i++) {
      final start = -3.141592653589793 / 2 + i * sweep + gapAngle / 2;
      final sweepAngle = sweep - gapAngle;
      final bool isActiveSegment = i <= activeIndex;
      paint.color = isActiveSegment ? activeColor : inactiveColor;
      canvas.drawArc(rect, start, sweepAngle, false, paint);
    }
  }

  double radians(double deg) => deg * (3.141592653589793 / 180);

  @override
  bool shouldRepaint(covariant _SegmentedRingPainter oldDelegate) {
    return oldDelegate.activeIndex != activeIndex ||
        oldDelegate.segments != segments ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
