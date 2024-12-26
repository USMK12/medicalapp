import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/bottomnav.dart';
import 'dart:convert';
import 'package:medicalapp/ip.dart';

class score extends StatefulWidget {
  final String pid;

  score({required this.pid});
  @override
  State<score> createState() => _scoreState();
}

class _scoreState extends State<score> {
  String scoreValue = '5';
  String scoreinf = '53';

  @override
  void initState() {
    super.initState();
    
    getScoreData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
            
            Image.asset(
              'assets/image 4.png', 
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
           
            Container(
              width: 400,
              height: 250,
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
                          scoreValue,
                          //scoreValue,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Inference : "+scoreinf+" Mortality",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50), 
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>botnav()), 
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
              ),
              child: Text('Submit',style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }

  
  void getScoreData() async {
    String url = scoreshowurl; 
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> postData = {'id': widget.pid};

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(postData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        int score = responseData['score'];
        
        // Mapping score to percentage
        String percentage;
        switch (score) {
          case 0:
          case 1:
            percentage = '0%';
            break;
          case 2:
            percentage = '7%';
            break;
          case 3:
            percentage = '16%';
            break;
          case 4:
            percentage = '26%';
            break;
          case 5:
            percentage = '53%';
            break;
          case 6:
            percentage = '61%';
            break;
          default:
            percentage = 'Unknown';
        }
        
        setState(() {
          scoreValue = score.toString();
          scoreinf = percentage;
        });
      } else {
        print('Failed to load score data: ${response.statusCode}');
      }
    } catch (error) {
      print('Network error: $error');
    }
  }

}
