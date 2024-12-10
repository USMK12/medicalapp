import 'package:flutter/material.dart';
import 'package:medicalapp/firstpage.dart';
import 'dart:io';

import 'package:medicalapp/score.dart';
import 'package:medicalapp/values.dart';

void main() {
  
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:beforefirst() ,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
