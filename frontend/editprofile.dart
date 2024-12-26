import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medicalapp/bottomnav.dart';
import 'package:medicalapp/doctorhome.dart';
import 'package:medicalapp/ip.dart';

class editprofile extends StatefulWidget {
  final String pid;

  editprofile({required this.pid});

  
  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {

  @override
  void initState() {
    super.initState();
    fetchUserDetails(); 
  }

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();

  DateTime? _selectedDate;
  String _status = 'alive'; 
  String _pid='';
  Uint8List? _profileImage;

  
  Future<void> fetchUserDetails() async {
    final response = await http.post(
      Uri.parse(profileuri),
      headers: {'Content-Type': 'application/json'}, // Ensure content type is JSON
      body: jsonEncode({'id': widget.pid}), // Send JSON data
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);
      
      if (userData.isNotEmpty) {
        setState(() {
          _pid = userData['pid'] ?? '';
          _firstNameController.text = userData['firstname'] ?? '';
          _lastNameController.text = userData['lastname'] ?? '';
          
          if (userData['dob'] != null && userData['dob'].isNotEmpty) {
            try {
              _selectedDate = DateFormat('MM/dd/yyyy').parse(userData['dob']);
              _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
            } catch (e) {
              print('Error parsing date: $e');
            }
          } else {
            _dobController.text = ''; // Clear the DOB field if null
          }


          _sexController.text = userData['gender'] ?? '';
          _heightController.text = userData['height'] ?? '';
          _weightController.text = userData['weight'] ?? '';
          _bloodGroupController.text = userData['bloodgroup'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
        });
      } else {
        print("No user data found");
      }
    } else {
      throw Exception('Failed to load user details');
    }
  }



void sendDataToServer() async {
  if (_selectedDate == null) {
    // Show an error message if the date is not selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select a date of birth')),
    );
    return;
  }

  String firstName = _firstNameController.text;
  String lastName = _lastNameController.text;
  String dob = DateFormat('yyyy-MM-dd').format(_selectedDate!);
  String gender = _sexController.text;
  String height = _heightController.text;
  String weight = _weightController.text;
  String bloodGroup = _bloodGroupController.text;
  String phone = _phoneController.text;
  String patientStatus = _status;

  var url = Uri.parse(editprofileurl);

  var data = {
    'pid': widget.pid.toString(),
    'firstname': firstName,
    'lastname': lastName,
    'dob': dob,
    'sex': gender,
    'height': height,
    'weight': weight,
    'bloodgroup': bloodGroup,
    'phone': phone,
    'patientstatus': patientStatus,
  };

  try {
    var jsonData = jsonEncode(data);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('Data sent successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => botnav()),
      );
    } else {
      print('Failed to send data. Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error encoding JSON: $e');
  }
}





  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color : Colors.white,
        ),
        backgroundColor: appcolor,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: appcolor,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextWithInputField(controller: _firstNameController, label: 'First Name',),
              TextWithInputField(controller: _lastNameController, label: 'Last Name',),
              InkWell(
                onTap: () => _selectDate(context),
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      labelText: 'Date of Birth',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextWithInputField(controller: _sexController, label: 'Sex',),
              TextWithInputField(controller: _heightController, label: 'Height',),
              TextWithInputField(controller: _weightController, label: 'Weight',),
              TextWithInputField(controller: _bloodGroupController, label: 'Blood Group',),
              TextWithInputField(controller: _phoneController, label: 'Phone Number', keyboardType: TextInputType.phone,),
              Row(
                
                children: [
                  Radio(
                    value: 'alive',
                    groupValue: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value.toString();
                      });
                    },
                  ),
                  Text('Alive', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                  SizedBox(width: 190,),
                  Radio(
                    value: 'dead',
                    groupValue: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value.toString();
                      });
                    },
                  ),
                  Text('Dead', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ],
              ),
              ElevatedButton(
                onPressed: sendDataToServer,
                child: Text('Done', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class TextWithInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  

  const TextWithInputField({Key? key, required this.controller, required this.label,this.obscureText = false, this.keyboardType = TextInputType.text}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 7.5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            
            hintStyle: TextStyle(color: Colors.black),
            fillColor: Colors.white70,
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
