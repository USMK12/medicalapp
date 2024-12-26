import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/ip.dart';

class downloaddata extends StatefulWidget {
  @override
  State<downloaddata> createState() => _downloaddataState();
}

class _downloaddataState extends State<downloaddata> {
  bool _isDownloading = false;

  Future<void> downloadCSV(BuildContext context) async {
    setState(() {
      _isDownloading = true;
    });

     // Replace with your actual API URL

    try {
      final response = await http.get(Uri.parse(downloadurl));
      if (response.statusCode == 200) {
        String? directoryPath = await FilePicker.platform.getDirectoryPath();
        if (directoryPath == null) {
          Fluttertoast.showToast(
            msg: 'No Directory Selected',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          return;
        }
        String fileName =
            'patient_details_${DateTime.now().millisecondsSinceEpoch}.csv';
        String filePath = '$directoryPath/$fileName';
        File file = File(filePath);
        int counter = 1;
        while (await file.exists()) {
          fileName =
              'patient_details_${DateTime.now().millisecondsSinceEpoch}_$counter.csv';
          filePath = '$directoryPath/$fileName';
          file = File(filePath);
          counter++;
        }
        await file.writeAsBytes(response.bodyBytes);
        print('CSV saved at: $filePath');
        Fluttertoast.showToast(
          msg: 'Saved Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Error Downloading CSV',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Patient Data'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isDownloading)
              CircularProgressIndicator()
            else
              GestureDetector(
                onTap: () {
                  downloadCSV(context); // Start the download when tapped
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Download Patient Data',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
