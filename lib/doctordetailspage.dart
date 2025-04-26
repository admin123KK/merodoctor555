import 'package:flutter/material.dart';

class Doctordetailspage extends StatefulWidget {
  const Doctordetailspage({super.key});

  @override
  State<Doctordetailspage> createState() => _DoctordetailspageState();
}

class _DoctordetailspageState extends State<Doctordetailspage> {
  Color containerColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 45,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                      color: const Color.fromARGB(90, 28, 165, 172),
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
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        '  Orthopedist',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '  Active',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      Text('  5 Year Experience')
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  'About',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'An Orthopedist is a medical doctor who specializes in diagnosing,treating and preventing conditions related \nto the bones,joints, muscles, ligaments,and tendons.\nThey help manage injuries, architures fractures on the \nmusculoskeletal issues.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: Text(
                  'Schedule for Appointment',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 60,
                  width: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF1CA4AC)),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Sun',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('10'),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF1CA4AC),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Mon',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('11')
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF1CA4AC)),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Tue',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('12')
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF1CA4AC)),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Wed',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('13')
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      containerColor = containerColor == Colors.white
                          ? Color(0xFF1CA4AC)
                          : Colors.white;
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 50,
                    decoration: BoxDecoration(
                        color: containerColor,
                        border: Border.all(color: Color(0xFF1CA4AC)),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Thu',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('14')
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF1CA4AC)),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Fri',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('15')
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF1CA4AC)),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Sat',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('16'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: const Divider(
              color: Color(0xFF1CA4AC),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 90,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF1CA4AC)),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text('5.55')),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF1CA4AC)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text('5.55')),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF1CA4AC)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text('5.55')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 90,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF1CA4AC)),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text('5.55')),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF1CA4AC)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text('5.55')),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF1CA4AC)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text('5.55')),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 90,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF1CA4AC)),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text('5.55')),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF1CA4AC)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text('5.55')),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF1CA4AC)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text('5.55')),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 90,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF1CA4AC)),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text('5.55')),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF1CA4AC)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text('5.55')),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF1CA4AC)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text('5.55')),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
