import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medicalapp/ip.dart';
import 'package:medicalapp/uploadimage.dart';
import 'package:medicalapp/viewprofile.dart';

class Patient {
  final String pid;
  final String firstname;
  final String profilepic;
  Patient(this.firstname, this.pid, this.profilepic);
}

class Mywidget1 extends StatelessWidget {
  final String username;
  final String pid;
  final String profilepic;

  Mywidget1({required this.username, required this.pid,required this.profilepic});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 230,
      height: 120,
      margin: EdgeInsets.only(left:30,top: 5,right: 30,bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), 
            spreadRadius: 3,
            blurRadius: 3,
            offset: Offset(0, 2), 
          ),
        ],
        color: appcolor,
        border: Border.all(
          color: Colors.white,
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
                          MaterialPageRoute(builder: (context) => viewprofile(pid: pid)), 
                        );
                      },  
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.white,
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
                          MaterialPageRoute(builder: (context) => uploadimage(pid: pid)), 
                        );
                      },  
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.white,
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

class patientList extends StatefulWidget {
  @override
  _patientListState createState() => _patientListState();
}

class _patientListState extends State<patientList> {
  List<Patient> patientList = [];
  List<Patient> filteredList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    //String url = "http://"+ip+"/medicalapp/patientlist.php";
    makeRequest(patientlisturl);
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
    tempPatientList.add(Patient(
      item['firstname'] ?? 'Unknown',  // Fallback if null
      item['pid'] ?? '',               // Ensure pid is not null
      item['profilepic'] ?? '/images/image.png'  // Fallback to default image if null
    ));
  }
  setState(() {
    patientList = tempPatientList;
    filteredList = patientList;
  });
}


  void filterPatientList(String searchText) {
    List<Patient> tempFilteredList = [];
    searchText = searchText.toLowerCase().trim();
    if (searchText.isEmpty) {
      tempFilteredList = patientList;
    } else {
      for (var patient in patientList) {
        if (patient.firstname.toLowerCase().contains(searchText)) {
          tempFilteredList.add(patient);
        }
      }
    }
    setState(() {
      filteredList = tempFilteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color : Colors.white,
        ),  
        title: Text('Total Doctor Activity',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: appcolor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:20.0,top:20,right: 20,bottom: 20),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterPatientList(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return Mywidget1(
                  username: filteredList[index].firstname,
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