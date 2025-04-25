import 'package:flutter/material.dart';
import 'package:merodoctor/profilepage.dart';

class Reportcheck extends StatefulWidget {
  const Reportcheck({super.key});

  @override
  State<Reportcheck> createState() => _ReportcheckState();
}

class _ReportcheckState extends State<Reportcheck> {
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
            onTap: () {},
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
