import 'package:flutter/material.dart';
import 'package:educam_ai/theme/app_theme.dart';

class AiAvatar extends StatelessWidget {
  final double size;
  final bool isOnline;

  const AiAvatar({
    super.key,
    this.size = 40,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [EduCamColors.accent, Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: EduCamColors.accent.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.5,
          height: size * 0.5,
          child: CustomPaint(
            painter: _AiMarkPainter(),
          ),
        ),
      ),
    );
  }
}

class _AiMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = EduCamColors.surface.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..lineTo(size.width * 0.3, size.height * 0.3)
      ..lineTo(size.width * 0.5, size.height * 0.65)
      ..lineTo(size.width * 0.7, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.7);

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = EduCamColors.surface.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.06,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
