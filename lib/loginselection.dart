
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:medicalapp/adminlogin.dart';
import 'package:medicalapp/doctorlogin.dart';
import 'package:medicalapp/ip.dart';

class loginselection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children:[
            Image.asset(
              'assets/image1.png',
              
            ),
            Container( 
              width: double.infinity,

              child: Container(
                
                width: 100,
                height: 543.5,
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                ),
                decoration: BoxDecoration(
                  color: appcolor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 0),
                      _buildDoctorButton(context,"DOCTOR",'assets/image 2.png',"Doctorlogin"
                      ),
                      SizedBox(height: 70),
                      _buildDoctorButton(context,"ADMIN",'assets/image 3.png',"adminlogin"
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  

  Widget _buildDoctorButton(BuildContext context, String text, String imgpath, String page) {
  return ElevatedButton(
    onPressed: () {
      if (page == "Doctorlogin") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorLogin()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => admin()),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: AlignmentDirectional.centerStart,
      padding: EdgeInsets.all(20),
    ),
    child: Row(
      children: [
        Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 175),
        Image.asset(
          imgpath,
          width: 40,
          height: 45,
          alignment: Alignment.centerRight,
        ),
      ],
    ),
  );
}

  
}

