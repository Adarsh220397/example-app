import 'package:flutter/rendering.dart';

class DrawTriangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(0, 10);
    path.lineTo(290, 150);
    path.lineTo(0, 150);

    path.close();
    canvas.drawPath(path, Paint()..color = const Color.fromARGB(220, 0, 0, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
