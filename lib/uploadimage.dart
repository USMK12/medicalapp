import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicalapp/calculatescore.dart';
import 'package:medicalapp/ip.dart';

class uploadimage extends StatefulWidget {
  final String pid; // Add pid parameter to the constructor

  // Constructor with pid parameter
  uploadimage({required this.pid});

  @override
  _uploadimageState createState() => _uploadimageState();
}

class _uploadimageState extends State<uploadimage> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color : Colors.white,
        ),
        title: Text('Image Measurement',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: appcolor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            GestureDetector(
              onTap: getImage,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.scaleDown)
                    : Icon(
                  Icons.add_a_photo,
                  size: 50,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to CalculateScreen passing selected image and pid
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalculateScreen(
                      imageFile: _image,
                      pid: widget.pid, // Pass the pid here
                    ),
                  ),
                );
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
