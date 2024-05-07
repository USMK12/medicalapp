import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert';

import 'package:medicalapp/ip.dart';
import 'package:medicalapp/score.dart'; // Import convert for JSON encoding

class values extends StatefulWidget {
  final String pid;

  values({required this.pid});
  @override
  State<values> createState() => _valuesState();
}

class _valuesState extends State<values> {
  TextEditingController bacilController = TextEditingController();
  TextEditingController midlineController = TextEditingController();
  TextEditingController massController = TextEditingController();
  TextEditingController intraventricularController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color : Colors.white,
          ),
          title: Text('Calculate Score',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          backgroundColor: appcolor,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 400,
              height: 800,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: appcolor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInputRow("Bacil Cisterns", bacilController),
                  _buildInputRow("Midline Shift", midlineController),
                  _buildInputRow("Epidual Mass Lesion", massController),
                  _buildInputRow("Intraventricular blood\n/Subarachnoid hemorrage", intraventricularController),
                  SizedBox(height: 20), // Added space between input rows and button
                  ElevatedButton(
                    onPressed: () {
                      sendDataToPHP();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => score(pid : widget.pid)), // Navigating to the Login screen
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Button background color
                    ),
                    child: Text('Submit',style: TextStyle(color: Colors.black),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(String labelText, TextEditingController controller) {
    return Container(
      height: 150,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelText,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Enter ',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendDataToPHP() async {
    String bacil = bacilController.text;
    String midline = midlineController.text;
    String mass = massController.text;
    String intraventricular = intraventricularController.text;

    String url = scoreurl; // Replace with your PHP script URL
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> data = {
      'pid': widget.pid,
      'bacil': bacil,
      'midline': midline,
      'mass': mass,
      'intraventricular': intraventricular,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      );

      // Handle the response here if needed
      print(response.body);
    } catch (error) {
      // Handle error
      print('Error: $error');
    }
  }
}
