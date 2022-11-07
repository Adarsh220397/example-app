import 'package:flutter/rendering.dart';

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color.fromARGB(17, 228, 222, 228)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(0, 0), 65, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
