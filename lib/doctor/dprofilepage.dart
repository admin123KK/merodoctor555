import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merodoctor/chatbotpage.dart';
import 'package:merodoctor/doctor/dhomepage.dart';
import 'package:merodoctor/historyorsavedpage.dart';
import 'package:merodoctor/homepage.dart';
import 'package:merodoctor/loginpage.dart';
import 'package:merodoctor/reportcheck.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dprofilepage extends StatefulWidget {
  const Dprofilepage({super.key});

  @override
  State<Dprofilepage> createState() => _DprofilepageState();
}

class _DprofilepageState extends State<Dprofilepage> {
  File? _profileImage;
  Future<void> _pickImage() async {
    final PickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        _profileImage = File(PickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1CA4AC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Homepage()));
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 27,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Expanded(
                      child: const Text(
                        'Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 26),
                      ),
                    ),
                    const Icon(
                      Icons.more_vert,
                      size: 26,
                      color: Colors.white,
                    ),
                  ],
                )),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/image/startpage3.png')
                          as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Dr.Sky Karki',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 60,
                  width: 1,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey],
                      stops: [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const Column(
                  children: [
                    const Text(
                      'Sex',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Male',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                  height: 60,
                  width: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey],
                        stops: [0.0, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    color: Colors.white,
                  ),
                ),
                const Column(
                  children: [
                    const Text(
                      'Age',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '27',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                  height: 60,
                  width: 1,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 480,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(90, 28, 165, 172)),
                          child: const Icon(Icons.favorite_outline),
                        ),
                      ),
                      const Text(
                        'Patient Record ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Historyorsavedpage()));
                          },
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(90, 28, 165, 172),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.qr_code_rounded),
                        ),
                      ),
                      const Text(
                        'Report Check',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Reportcheck()));
                          },
                          child: const Icon(
                            Icons.chevron_right_outlined,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(90, 28, 165, 172),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.person_search_outlined),
                        ),
                      ),
                      const Text(
                        'Appointment',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: const Icon(
                          Icons.chevron_right_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(90, 28, 165, 172),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.settings_outlined),
                        ),
                      ),
                      const Text(
                        'Settings',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: const Icon(
                          Icons.chevron_right_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(90, 28, 165, 172),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.message_outlined),
                        ),
                      ),
                      const Text(
                        "FAQs",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chatbotpage()));
                          },
                          child: const Icon(
                            Icons.chevron_right_outlined,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(90, 28, 165, 172),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.logout_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const Text(
                        'Log out',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Are you sure ?',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    icon: const Icon(
                                      Icons.logout_outlined,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Color(0xFF1CA4AC)),
                                              )),
                                          InkWell(
                                            onTap: () async {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.remove('token');
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: Color(0xFF1CA4AC),
                                                    ));
                                                  });
                                              await Future.delayed(
                                                  const Duration(seconds: 2));
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Loginpage()));
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 75,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF1CA4AC),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: const Center(
                                                child: Text(
                                                  'Log out ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: const Icon(
                            Icons.chevron_right_outlined,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 3)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dhomepage()));
                  },
                  child: const Icon(Icons.home_outlined, size: 30)),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Reportcheck()));
                },
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 30,
                ),
              ),
              const Icon(Icons.calendar_month_outlined, size: 30),
              const Icon(Icons.person_outline,
                  color: Color(0xFF1CA4AC), size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
