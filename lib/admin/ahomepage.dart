import 'package:flutter/material.dart';
import 'package:merodoctor/admin/amessage.dart';
import 'package:merodoctor/admin/dadminpage.dart';
import 'package:merodoctor/admin/patiadminpage.dart';

import '../doctor/dprofilepage.dart';

class Ahomepage extends StatefulWidget {
  const Ahomepage({super.key});

  @override
  State<Ahomepage> createState() => _AhomepageState();
}

class _AhomepageState extends State<Ahomepage> {
  String greeting = "";

  @override
  void initState() {
    updateGreeting();
    super.initState();
  }

  void updateGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Mero Doctor',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text('$greeting,  Karki'),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 750,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Admin Pannel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          height: 130,
                          width: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(93, 28, 165, 172),
                              borderRadius: BorderRadius.circular(15)),
                          child: const Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Icon(
                                Icons.person_outline,
                                size: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  '  Total\nPatients',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                '108',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Container(
                          height: 130,
                          width: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(93, 28, 165, 172),
                              borderRadius: BorderRadius.circular(15)),
                          child: const Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Icon(
                                Icons.person_4_outlined,
                                size: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  '  Total\nDoctors',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                '108',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(93, 28, 165, 172),
                              borderRadius: BorderRadius.circular(15)),
                          child: const Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Icon(
                                Icons.calendar_month_outlined,
                                size: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  'Appointments',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                '369',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(93, 28, 165, 172),
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Doctor',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: InkWell(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => const Center(
                                              child: CircularProgressIndicator(
                                                color: Color(0xFF1CA4AC),
                                              ),
                                            ));
                                    await Future.delayed(Duration(seconds: 2));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DAdminPage()));
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF1CA4AC),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                      child: Text(
                                        'EDIT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ))),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(93, 28, 165, 172),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Patients',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) => const Center(
                                            child: CircularProgressIndicator(
                                          color: Color(0xFF1CA4AC),
                                        )));
                                await Future.delayed(Duration(seconds: 2));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PAdminPage()));
                              },
                              child: Container(
                                height: 30,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1CA4AC),
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Center(
                                  child: Text(
                                    'EDIT',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 3,
                offset: Offset(0, 2),
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.home_outlined,
                size: 30,
                color: Color(0xFF1CA4AC),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Amessage()));
                },
                child: const Icon(
                  Icons.mail_outline,
                  size: 30,
                ),
              ),
              const Icon(
                Icons.calendar_month_outlined,
                size: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dprofilepage()));
                },
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDoctorCard(
    String imagePath, String name, String type, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.only(right: 15),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Container(
        width: 160,
        height: 230,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color.fromARGB(93, 28, 165, 172),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 58,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              type,
              style: const TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: onTap,
              child: Container(
                height: 20,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: InkWell(
                    child: Text(
                      'Visit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
