import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/profilepage.dart';

class Reportcheck extends StatefulWidget {
  const Reportcheck({super.key});

  @override
  State<Reportcheck> createState() => _ReportcheckState();
}

class _ReportcheckState extends State<Reportcheck> {
  Future<void> pickAndUploadFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      await uploadFile(file);
    }
  }

  Future<void> uploadFile(File file) async {
    final uri = Uri.parse('https://your-backend-url.com/api/upload');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Upload successful');
    } else {
      print('Upload failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profilepage()));
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 100,
                ),
                const Text(
                  'Check X-RAY',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                ),
              ],
            ),
          ),
          const Text(
            'Phneumonia Detection',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF1CA4AC)),
          ),
          const SizedBox(
            height: 7,
          ),
          const Text(
            'AI powred analyatic of chest x-rays for rapid and accurate \nphneumonia detection ',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Upload file to check your report',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 110,
            width: 170,
            decoration: BoxDecoration(
                color: const Color.fromARGB(90, 28, 165, 172),
                borderRadius: BorderRadius.circular(20)),
            child: const Icon(
              Icons.upload_file,
              size: 75,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: pickAndUploadFile,
            child: Container(
              height: 30,
              width: 123,
              decoration: BoxDecoration(
                  color: Color(0xFF1CA4AC),
                  borderRadius: BorderRadius.circular(20)),
              child: const Center(
                child: Text(
                  'Upload',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          // const Text(
          //   'Wait a while report is being ready',
          //   style: TextStyle(color: Colors.grey),
          // )
        ],
      ),
    );
  }
}
