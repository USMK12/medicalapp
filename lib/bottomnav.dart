import 'package:flutter/material.dart';
import 'package:medicalapp/addpatient.dart';
import 'package:medicalapp/analysis.dart';
import 'package:medicalapp/doctorhome.dart';
import 'package:medicalapp/ip.dart';
import 'package:medicalapp/patientlist.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      
      home: botnav(),
    );
  }
}

class botnav extends StatefulWidget {
  @override
  _botnavState createState() => _botnavState();
}

class _botnavState extends State<botnav> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    doctorhome(),
    addpatient(),
    patientList(),
    barchart(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: appcolor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_outlined),
            label: 'Add Patient',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_sharp),
            label: 'Patient List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Bar Chart',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}