import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medicalapp/bottomnav.dart';
import 'package:medicalapp/ip.dart';

class addpatient extends StatefulWidget {
  @override
  State<addpatient> createState() => _addpatientState();
}

class _addpatientState extends State<addpatient> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();

  DateTime? _selectedDate;

  void sendDataToServer() async {
    
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String dob = DateFormat('yyyy-MM-dd').format(_selectedDate!); 
    String sex = _sexController.text;
    String height = _heightController.text;
    String weight = _weightController.text;
    String bloodGroup = _bloodGroupController.text;
    String phone = _phoneController.text;

     if (firstName.isEmpty ||
        lastName.isEmpty ||
        dob.isEmpty ||
        sex.isEmpty ||
        height.isEmpty ||
        weight.isEmpty ||
        bloodGroup.isEmpty ||
        phone.isEmpty) {
          
          print('Please fill in all fields');
          return;
        }

    var url = Uri.parse(registerurl);
    var response = await http.post(
      url,
      body: {
        'firstname': firstName,
        'lastname': lastName,
        'dob': dob,
        'sex': sex,
        'height': height,
        'weight': weight,
        'bloodgroup': bloodGroup,
        'phone': phone,
      },
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
  }

  // Function to handle date selection
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
          'Add Patient',
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
              TextWithInputField(controller: _firstNameController, label: 'First Name'),
              TextWithInputField(controller: _lastNameController, label: 'Last Name'),
              InkWell(
                onTap: () => _selectDate(context),
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      labelText: 'Date of Birth',labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              TextWithInputField(controller: _sexController, label: 'Sex'),
              TextWithInputField(controller: _heightController, label: 'Height'),
              TextWithInputField(controller: _weightController, label: 'Weight'),
              TextWithInputField(controller: _bloodGroupController, label: 'Blood Group'),
              TextWithInputField(controller: _phoneController, label: 'Phone Number', keyboardType: TextInputType.phone),
              ElevatedButton(
                onPressed: sendDataToServer,
                child: Text('Done',style: TextStyle(fontWeight: FontWeight.bold),),
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

  const TextWithInputField({Key? key, required this.controller, required this.label, this.obscureText = false, this.keyboardType = TextInputType.text}) : super(key: key);

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
