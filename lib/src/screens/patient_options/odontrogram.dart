import 'package:flutter/material.dart';

class OdotogramScreen extends StatefulWidget {
  const OdotogramScreen({super.key});

  @override
  OdotogramScreenState createState() => OdotogramScreenState();
}

class OdotogramScreenState extends State<OdotogramScreen> {
  List<Offset> points = [];
  final GlobalKey _imageKey = GlobalKey(); // Track image position

  void _addPoint(DragUpdateDetails details) {
    final RenderBox? renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      // Convert touch coordinates to the image's local space
      Offset localOffset = renderBox.globalToLocal(details.globalPosition);
      setState(() {
        points.add(localOffset);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Odontograma')),
      body: GestureDetector(
        onPanUpdate: _addPoint,
        onPanEnd: (details) => points.add(Offset.infinite),
        child: Center(
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 3.0,
                  child: Center(
                    child: Image.asset(
                      'lib/src/assets/images/odontograma.jpg',
                      key: _imageKey,
                      fit: BoxFit.contain, // Ensures the full image fits on the screen
                      width: double.infinity, // Ensures full width usage
                      height: double.infinity, // Ensures full height usage
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: OdotogramPainter(points),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            points.clear();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class OdotogramPainter extends CustomPainter {
  final List<Offset> points;

  OdotogramPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 210, 61, 236)
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.square;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }

    // Draw purple dots at each point
    Paint dotPaint = Paint()..color = Colors.purple;
    for (Offset point in points) {
      if (point != Offset.infinite) {
        canvas.drawCircle(point, 4.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(OdotogramPainter oldDelegate) => true;
}
