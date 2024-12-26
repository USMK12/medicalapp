import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/ip.dart'; // Ensure this is defined properly
import 'package:medicalapp/loginselection.dart';
import 'package:medicalapp/registerdoctor.dart';
import 'dart:convert';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> doctors = [];
  List<dynamic> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    final response = await http.get(Uri.parse(docdet)); // Ensure 'docdet' is defined

    print("Response body: ${response.body}"); // Debug line to check the response

    if (response.statusCode == 200) {
      final List<dynamic> doctorList = jsonDecode(response.body);
      setState(() {
        doctors = doctorList;
        filteredDoctors = doctorList;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load doctors')),
      );
    }
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredDoctors = doctors;
      });
    } else {
      setState(() {
        filteredDoctors = doctors.where((doctor) {
          final name = doctor['name']?.toLowerCase() ?? ''; // Use null-aware operator
          final username = doctor['username']?.toLowerCase() ?? ''; // Use null-aware operator
          final searchQuery = query.toLowerCase();
          return name.contains(searchQuery) || username.contains(searchQuery);
        }).toList();
      });
    }
  }

  Future<void> deleteDoctor(String doctorId) async {
    final response = await http.post(
      Uri.parse(deletedoctor), // Update this URL to your PHP script
      body: {'Did': doctorId}, // Ensure your PHP script expects this parameter
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success'] == true) {
        // If the deletion was successful, refresh the list
        fetchDoctors();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doctor deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete doctor')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting doctor')),
      );
    }
  }

  void showDoctorDetails(Map<String, dynamic> doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Doctor Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name: ${doctor['name']}'),
                Text('Username: ${doctor['username']}'),
                Text('Age: ${doctor['age']}'),
                Text('Gender: ${doctor['gender']}'),
                Text('Contact: ${doctor['contact']}'),
                Text('Specialist: ${doctor['specialist']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // Confirm before deletion
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Deletion'),
                      content: Text('Are you sure you want to delete this doctor?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the confirmation dialog
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            deleteDoctor(doctor['Did']); // Use the Did field for deletion
                            Navigator.of(context).pop(); // Close the details dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AdminHomePage()),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, Admin'),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or username',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) => filterDoctors(query),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];
                  return GestureDetector(
                    onTap: () => showDoctorDetails(doctor),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: appcolor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        
                        children: <Widget>[
                          Text('Name: ${doctor['name']}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Username: ${doctor['username']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: appcolor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterDoctorPage()),
                );
              },
              child: Text('Add Doctor',style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}
