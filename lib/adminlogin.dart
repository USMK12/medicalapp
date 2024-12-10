import 'dart:async';
import 'dart:convert'; // Add this import
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medicalapp/adminhome.dart';
import 'package:medicalapp/bottomnav.dart';
import 'package:medicalapp/doctorhome.dart';
import 'package:medicalapp/ip.dart';

class admin extends StatefulWidget {
  @override
  _adminState createState() => _adminState();
}

class _adminState extends State<admin> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        String response = await _sendLoginRequest(username, password);
        _handleResponse(response);
      } catch (e) {
        _handleError(e);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fields cannot be empty'),
      ));
    }
  }

  Future<String> _sendLoginRequest(String username, String password) async {
    String url = adminlogin;
    print(url);
    Map<String, String> data = {'username': username, 'password': password};

    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'}, // Set headers
      body: jsonEncode(data), // Encode data as JSON
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _handleResponse(String response) {
    print('JSON Response: $response');

    try {
      if (response.toLowerCase().contains('success')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login successful'),
        ));
        // Clear text fields
        _usernameController.clear();
        _passwordController.clear();

        // Navigate to next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error parsing JSON'),
      ));
    }
  }

  void _handleError(dynamic error) {
    if (error is TimeoutException) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request timed out. Check your internet connection.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ADMIN Login',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/image1.png',
              width: 350,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                color: appcolor,
                borderRadius: BorderRadius.circular(40),
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
    TextEditingController controller =
        label == 'User ID' ? _usernameController : _passwordController;

    return TextField(
      controller: controller,
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
      onPressed: _login,
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
