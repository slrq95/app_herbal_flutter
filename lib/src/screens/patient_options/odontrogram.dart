import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';

class OdotogramScreen extends StatefulWidget {
  const OdotogramScreen({super.key});

  @override
  OdotogramScreenState createState() => OdotogramScreenState();
}

class OdotogramScreenState extends State<OdotogramScreen> {
  List<Offset> points = [];
  final GlobalKey _imageKey = GlobalKey();
  TextEditingController topNotesController = TextEditingController();
  TextEditingController bottomNotesController = TextEditingController();

  void _addPoint(DragUpdateDetails details) {
    final RenderBox? renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      Offset localOffset = renderBox.globalToLocal(details.globalPosition);
      setState(() {
        points.add(localOffset);
      });
    }
  }

  @override
  void dispose() {
    topNotesController.dispose();
    bottomNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.fillColor, // Dark background
      appBar: AppBar(
        title: const Text('Odontograma'),
        backgroundColor: Colors.white, // Match text fields
      ),
      body: Column(
        children: [
          _buildNotesField(topNotesController, 'Apuntes (Parte superior)'),
          Expanded(
            child: GestureDetector(
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
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(painter: OdotogramPainter(points)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildNotesField(bottomNotesController, 'Apuntes (Parte inferior)'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          setState(() {
            points.clear();
            topNotesController.clear();
            bottomNotesController.clear();
          });
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildNotesField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: const TextStyle(fontSize: 22.0, color: Colors.white), // White text
        controller: controller,
        maxLines: 8,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF1E1E1E), // Dark input background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.white30),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.purple),
          ),
        ),
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
      ..color = Colors.purple
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }

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
