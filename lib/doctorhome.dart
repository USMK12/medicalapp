import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/doctorlogin.dart';
import 'dart:convert';

import 'package:medicalapp/ip.dart';
import 'package:medicalapp/loginselection.dart';
import 'package:medicalapp/uploadimage.dart';
import 'package:medicalapp/viewprofile.dart';

class Patient {
  final String pid;
  final String username;
  final String profilepic;
  Patient(this.username, this.pid, this.profilepic);
}

class MyWidget extends StatelessWidget {
  final String username;
  final String pid;
  final String profilepic;

  MyWidget({required this.username, required this.pid, required this.profilepic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 120,
      margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 3,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
        color: appcolor,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage("http://" + ip + "/${profilepic}"),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                username,
                style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => viewprofile(pid: pid)), // Navigating to the Login screen
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'View Profile',
                        style: TextStyle(
                          fontFamily: 'sans-serif-medium',
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => uploadimage(pid: pid)), // Navigating to the Login screen
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Add Score',
                        style: TextStyle(
                          fontFamily: 'sans-serif-medium',
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class doctorhome extends StatefulWidget {
  @override
  _doctorhomeState createState() => _doctorhomeState();
}

class _doctorhomeState extends State<doctorhome> {
  List<Patient> patientList = [];
  List<Patient> filteredList = [];

  @override
  void initState() {
    super.initState();
    
    
    makeRequest(doctorhomeurl);
  }

  Future<void> makeRequest(String url) async {
    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        parseResponse(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading patient data'),
        ),
      );
    }
  }

  void parseResponse(String responseBody) {
    List<dynamic> data = json.decode(responseBody);
    List<Patient> tempPatientList = [];
    
    for (var item in data) {
      // Ensure the keys exist and are not null before accessing
      String username = item['firstname'] ?? 'Unknown User'; // Provide a default value
      String pid = item['pid'] ?? '0'; // Provide a default value
      String profilepic = item['profilepic'] ?? '/images/image.png'; // Use a default image

      tempPatientList.add(Patient(username, pid, profilepic));
    }
    
    setState(() {
      patientList = tempPatientList;
      filteredList = patientList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading : false,
        iconTheme: IconThemeData(
          color : Colors.white,
        ),
        title: Text(
          'Home Page',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: appcolor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => loginselection()), 
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/homeimage.jpg', 
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10), 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true, 
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return MyWidget(
                  username: filteredList[index].username,
                  pid: filteredList[index].pid,
                  profilepic: filteredList[index].profilepic,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
