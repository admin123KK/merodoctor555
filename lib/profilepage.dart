import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merodoctor/chatbotpage.dart';
import 'package:merodoctor/historyorsavedpage.dart';
import 'package:merodoctor/homepage.dart';
import 'package:merodoctor/loginpage.dart';
import 'package:merodoctor/reportcheck.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  File? _profileImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Homepage()));
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 27,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 30),
                  const Expanded(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 26),
                    ),
                  ),
                  const Icon(Icons.more_vert, size: 26, color: Colors.white),
                ],
              ),
            ),

            // Profile Image Section
            Stack(
              alignment: Alignment.bottomRight,
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
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child:
                          const Icon(Icons.edit, size: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            const Text('Dr.Sky Karki',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 30),

            // Sex and Age Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(height: 60, width: 1, color: Colors.white),
                const Column(
                  children: [
                    Text('Sex',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Male', style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                Container(height: 60, width: 1, color: Colors.white),
                const Column(
                  children: [
                    Text('Age',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white)),
                    SizedBox(height: 10),
                    Text('27', style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                Container(height: 60, width: 1, color: Colors.white),
              ],
            ),

            const SizedBox(height: 50),

            // White Container Section
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
                  profileTile(
                    icon: Icons.favorite_outline,
                    text: 'My Saved',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const Historyorsavedpage()));
                    },
                  ),
                  profileTile(
                    icon: Icons.qr_code_rounded,
                    text: 'Report Check',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Reportcheck()));
                    },
                  ),
                  profileTile(
                      icon: Icons.person_search_outlined, text: 'Appointment'),
                  profileTile(icon: Icons.settings_outlined, text: 'Settings'),
                  profileTile(
                      icon: Icons.message_outlined,
                      text: 'FAQs',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chatbotpage()));
                      }),
                  profileTile(
                    icon: Icons.logout_outlined,
                    text: 'Log out',
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Are you sure?'),
                            icon: const Icon(Icons.logout_outlined,
                                size: 30, color: Colors.red),
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
                                    child: const Text('Cancel',
                                        style: TextStyle(
                                            color: Color(0xFF1CA4AC))),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.remove('token');

                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color:
                                                            Color(0xFF1CA4AC)));
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
                                      height: 33,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF1CA4AC),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Center(
                                        child: Text('Log out ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 90,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Homepage()));
                },
                child: const Icon(Icons.home_outlined, size: 30),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Reportcheck()));
                },
                child: const Icon(Icons.qr_code_rounded, size: 30),
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

  Widget profileTile({
    required IconData icon,
    required String text,
    Color textColor = Colors.black,
    Color iconColor = Colors.black,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(90, 28, 165, 172),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: iconColor),
              ),
            ),
            Text(text,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: InkWell(
                onTap: onTap,
                child: Icon(Icons.chevron_right_outlined,
                    color: iconColor, size: 30),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Divider(),
        ),
      ],
    );
  }
}
