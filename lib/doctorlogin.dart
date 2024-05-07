import 'package:flutter/material.dart';
import 'package:medicalapp/bottomnav.dart';
import 'package:medicalapp/ip.dart';

class DoctorLogin extends StatefulWidget {
  @override
  _DoctorLoginState createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor Login',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          
          children: [
            Image.asset(
              'assets/image1.png', // Add your image asset path here
              width: 350,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                color: appcolor,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign in to your \naccount!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField('User ID'),
                  SizedBox(height: 20),
                  _buildTextField('Password', isPassword: true),
                  SizedBox(height: 30),
                  _buildSignInButton(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16,
          color: appcolor,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => botnav()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
      child: Text(
        'Sign In',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: appcolor,
        ),
      ),
    );
  }
}
