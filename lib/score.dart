import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/doctorhome.dart';
import 'dart:convert';
import 'package:medicalapp/ip.dart';

class score extends StatefulWidget {
  final String pid;

  score({required this.pid});
  @override
  State<score> createState() => _scoreState();
}

class _scoreState extends State<score> {
  String scoreValue = ''; // Variable to hold the score value

  @override
  void initState() {
    super.initState();
    // Call the function to fetch the score data when the widget initializes
    getScoreData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
          color : Colors.white,
        ),
          title: Text('Total score',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          centerTitle: true,
          backgroundColor: appcolor,
        ),
        backgroundColor: appcolor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image asset
              Image.asset(
                'assets/image 4.png', // Provide the path to your image asset
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20), // Adding space between image and container
              // Container with text display field
              Container(
                width: 400,
                height: 200,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prognosis score :',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            // Display the score value here
                            scoreValue,
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50), // Added space between input rows and button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>doctorhome()), // Navigating to the Login screen
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
    );
  }

  // Function to fetch the score data from PHP
  void getScoreData() async {
    String url = scoreshowurl; // Replace with your PHP script URL
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> postData = {'id': widget.pid};

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(postData),
      );

      if (response.statusCode == 200) {
        // Parse the response JSON and update the scoreValue variable
        Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          scoreValue = responseData['score'].toString();
        });
      } else {
        // Handle error response
        print('Failed to load score data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network error
      print('Network error: $error');
    }
  }
}
