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
            
            if (widget.imageFile != null)
              Center(
                child: Transform.rotate(
                  angle: _rotationAngle,
                  child: InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(double.infinity),
                    transformationController: _transformationController,
                    onInteractionUpdate: (details) {
                      
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

            
            Positioned.fill(
              child: Image.asset(
                'assets/brain2.png', 
                fit: BoxFit.fill,
              ),
            ),

            
            Positioned(
              bottom: 10.0,
              left: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Zoom',style: TextStyle(fontWeight: FontWeight.bold),),
                  Slider(
                    value: _transformationController.value.getMaxScaleOnAxis(),
                    min: 0.1,
                    max: 5.0,
                    onChanged: (value) {
                      _transformationController.value = Matrix4.identity()
                        ..translate(screenSize.width / 2, screenSize.height / 2)
                        ..scale(value) 
                        ..translate(-screenSize.width / 2, -screenSize.height / 2);
                    },
                    activeColor: appcolor, 
                  ),
                ],
              ),
            ),

            // Slider for rotation
            Positioned(
              right: 10.0,
              top: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Rotate',style: TextStyle(fontWeight: FontWeight.bold),),
                  Slider(
                    value: _rotationAngle,
                    min: -2 * 3.1415,
                    max: 2 * 3.1415, 
                    onChanged: (value) {
                      setState(() {
                        _rotationAngle = value;
                      });
                    },
                    activeColor: appcolor, 
                  ),
                ],
              ),
            ),

            
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
                child: Text('Calculate',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appcolor, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
