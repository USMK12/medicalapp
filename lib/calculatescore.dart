import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medicalapp/ip.dart';
import 'package:medicalapp/values.dart';

class CalculateScreen extends StatefulWidget {
  final File? imageFile;
  final String pid;

  const CalculateScreen({Key? key, required this.imageFile,required this.pid}) : super(key: key);

  @override
  _CalculateScreenState createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  final TransformationController _transformationController =
      TransformationController();
  double _rotationAngle = 0.0;
  Offset _lastOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      // Handle gestures for moving the background image
      onPanStart: (details) {
        _lastOffset = details.localPosition;
      },
      onPanUpdate: (details) {
        final offsetDelta = details.localPosition - _lastOffset;
        _lastOffset = details.localPosition;
        setState(() {
          _transformationController.value = Matrix4.translationValues(
            offsetDelta.dx,
            offsetDelta.dy,
            0,
          ) * _transformationController.value;
        });
      },


      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color : Colors.white,
          ),
          title: Text('Calculate Distance',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          backgroundColor: appcolor,
        ),
        body: Stack(
          children: [
            // Background image file with transform
            if (widget.imageFile != null)
              Center(
                child: Transform.rotate(
                  angle: _rotationAngle,
                  child: InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(double.infinity),
                    transformationController: _transformationController,
                    onInteractionUpdate: (details) {
                      // No need to setState here for zoom
                    },
                    child: Image.file(
                      widget.imageFile!,
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
              ),

            // Fixed foreground image asset
            Positioned.fill(
              child: Image.asset(
                'assets/brain2.png', // Change this to your asset name
                fit: BoxFit.fill,
              ),
            ),

            // Slider for zoom
            Positioned(
              bottom: 0.0,
              left: 50.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Zoom'),
                  Slider(
                    value: _transformationController.value.getMaxScaleOnAxis(),
                    min: 0.1,
                    max: 5.0,
                    onChanged: (value) {
                      _transformationController.value = Matrix4.identity()
                        ..translate(screenSize.width / 2, screenSize.height / 2) // Translate to center
                        ..scale(value) // Scale
                        ..translate(-screenSize.width / 2, -screenSize.height / 2); // Translate back
                    },
                    activeColor: appcolor, // Changed slider active color
                  ),
                ],
              ),
            ),

            // Slider for rotation
            Positioned(
              right: 10.0,
              top: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Rotate'),
                  Slider(
                    value: _rotationAngle,
                    min: -2 * 3.1415,
                    max: 2 * 3.1415, // 2*pi to complete one full rotation
                    onChanged: (value) {
                      setState(() {
                        _rotationAngle = value;
                      });
                    },
                    activeColor: appcolor, // Changed slider active color
                  ),
                ],
              ),
            ),

            // Elevated button
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => values(pid: widget.pid)),
                  );
                },
                child: Text('Calculate',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appcolor, // Set button background color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
