import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/bottomnav.dart';
import 'package:medicalapp/editprofile.dart';
import 'package:medicalapp/ip.dart';
import 'package:sizer/sizer.dart';

class viewprofile extends StatefulWidget {
  final String pid;

  viewprofile({required this.pid});
  @override
  _viewprofileState createState() => _viewprofileState();
}

class _viewprofileState extends State<viewprofile> {
  String _pid = '';
  String _firstname = '';
  String _lastname = '';
  String _gender = '';
  String _height = '';
  String _weight = '';
  String _bloodGroup = '';
  String _phone = '';
  String _dob = '';

  Uint8List? _profileImage;

  Future<void> fetchUserDetails() async {
    final response = await http.post(
      Uri.parse(profileuri),
      headers: {'Content-Type': 'application/json'}, // Specify JSON content type
      body: jsonEncode({'id': widget.pid}), // Send JSON data
    );
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        setState(() {
          _pid = userData['pid'] ?? '';
          _firstname = userData['firstname'] ?? '';
          _lastname = userData['lastname'] ?? '';
          _dob = userData['dob'] ?? '';
          _gender = userData['gender'] ?? '';
          _height = userData['height'] ?? '';
          _weight = userData['weight'] ?? '';
          _bloodGroup = userData['bloodgroup'] ?? '';
          _phone = userData['phone'] ?? '';
        });
      } catch (e) {
        print('JSON Decode Error: $e');
      }
    } else {
      print('Failed to load user details. Status Code: ${response.statusCode}');
    }
  }


  Future<bool> deleteProfile() async {
    final response = await http.post(
      Uri.parse(deleteUri),
      body: {'pid': _pid},
    );

    print('Response body: ${response.body}'); // Debugging line

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile deleted successfully')),
          );
          Navigator.pop(context);
          
          
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete profile')),
          );
        }
      } catch (e) {
        print('JSON Decode Error: $e'); // Additional debugging line
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid response from server')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Patient Detail',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: appcolor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Stack(
                  children: <Widget>[
                    _profileImage != null
                        ? CircleAvatar(
                            radius: 80,
                            backgroundColor: appcolor,
                            backgroundImage: AssetImage('assets/image 7.png'),
                          )
                        : const CircleAvatar(
                            radius: 80,
                            backgroundImage: AssetImage('assets/image 7.png'),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: appcolor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildRow('Patient ID', _pid),
                      SizedBox(height: 20),
                      buildRow('First Name', _firstname),
                      SizedBox(height: 20),
                      buildRow('Lastname', _lastname),
                      SizedBox(height: 20),
                      buildRow('Gender', _gender),
                      SizedBox(height: 20),
                      buildRow('Height', _height),
                      SizedBox(height: 20),
                      buildRow('Weight', _weight),
                      SizedBox(height: 20),
                      buildRow('Blood Group', _bloodGroup),
                      SizedBox(height: 20),
                      buildRow('Contact', _phone),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 75),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => editprofile(pid: _pid),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appcolor,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await deleteProfile(); // Update deleteProfile to return a boolean

                      if (success) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => botnav()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Delete Profile',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
