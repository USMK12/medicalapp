import 'package:flutter/material.dart';
import 'package:medicalapp/doctorlogin.dart';
import 'package:medicalapp/ip.dart';
import 'package:medicalapp/loginselection.dart';

class beforefirst extends StatefulWidget {
  const beforefirst({Key? key}) : super(key: key);

  @override
  State<beforefirst> createState() => _beforefirstState();
}

class _beforefirstState extends State<beforefirst> {
  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => loginselection()), 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(250, 250),
            painter: TrianglePainter(color: appcolor, topLeft: true),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CustomPaint(
              size: Size(250, 250),
              painter: TrianglePainter(color: appcolor, topLeft: false),
            ),
          ),
          Center(
            child: Text(
              'PROGNOSIS CALCULATOR',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  final bool topLeft;

  TrianglePainter({required this.color, required this.topLeft});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    Path path = Path();
    if (topLeft) {
      path.lineTo(size.width, 0);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, size.height);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
