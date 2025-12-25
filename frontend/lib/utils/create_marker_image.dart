import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<Uint8List> createMarkerImage(
  IconData icon,
  Color color, {
  double size = 160,
  double iconSize = 100,
}) async {
  final isWeb = kIsWeb;

  final canvasSize = isWeb ? 56.0 : size;
  final iconScale = canvasSize / size;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final radius = canvasSize / 2;
  final center = Offset(radius, radius);

  final paint = Paint()..color = color;
  canvas.drawCircle(center, radius, paint);

  final borderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = isWeb ? 3.0 : 6.0;
  canvas.drawCircle(center, radius - borderPaint.strokeWidth / 2, borderPaint);

  final textPainter = TextPainter(textDirection: TextDirection.ltr);
  textPainter.text = TextSpan(
    text: String.fromCharCode(icon.codePoint),
    style: TextStyle(
      fontSize: iconSize * iconScale,
      fontFamily: icon.fontFamily,
      package: icon.fontPackage,
      color: Colors.white,
    ),
  );
  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
  );

  final picture = recorder.endRecording();
  final img = await picture.toImage(canvasSize.toInt(), canvasSize.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
