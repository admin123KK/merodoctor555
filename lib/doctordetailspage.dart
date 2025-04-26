import 'package:flutter/material.dart';

class Doctordetailspage extends StatefulWidget {
  const Doctordetailspage({super.key});

  @override
  State<Doctordetailspage> createState() => _DoctordetailspageState();
}

class _DoctordetailspageState extends State<Doctordetailspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                ),
                Text(
                  'Doctor Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
                Icon(
                  Icons.more_vert,
                  size: 30,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Container(
                  height: 150,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.asset('assets/image/startpage2.png'),
                ),
                Container(
                  height: 130,
                  width: 150,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '  Dr.Sky Karki',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Text(
                        '  Orthopedist',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text('  Active'),
                      Text('  5 Years')
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text('hi')
        ],
      ),
    );
  }
}
