import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:merodoctor/admin/amessage.dart';
import 'package:merodoctor/api.dart';
import 'package:merodoctor/chatbotpage.dart';
import 'package:merodoctor/doctor/dhomepage.dart';
import 'package:merodoctor/historyorsavedpage.dart';
import 'package:merodoctor/loginpage.dart';
import 'package:merodoctor/reportcheck.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Adminprofile extends StatefulWidget {
  const Adminprofile({super.key});

  @override
  State<Adminprofile> createState() => _AdminprofileState();
}

class _AdminprofileState extends State<Adminprofile> {
  File? _profileImage;
  String fullName = '';
  String email = '';

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> fetchAdminProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    final url = Uri.parse(ApiConfig.adminProfileUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        fullName = data['data']['fullName'] ?? '';
        email = data['data']['email'] ?? '';
      });
    } else {
      print('Failed to fetch admin profile');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAdminProfile();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 27,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
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
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 55,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/image/startpage3.png')
                          as ImageProvider,
                ),
                Positioned(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              fullName.isNotEmpty ? fullName : 'Loading...',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              email.isNotEmpty ? email : 'Loading...',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 70),
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
                  const SizedBox(
                    height: 30,
                  ),
                  buildProfileItem(Icons.favorite_outline, 'Patient Record',
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Historyorsavedpage()));
                  }),
                  buildProfileItem(Icons.receipt_long_outlined, 'Report Check',
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Reportcheck()));
                  }),
                  buildProfileItem(
                      Icons.person_search_outlined, 'Appointment', () {}),
                  buildProfileItem(Icons.settings_outlined, 'Settings', () {}),
                  buildProfileItem(Icons.message_outlined, 'FAQs', () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Chatbotpage()));
                  }),
                  buildProfileItem(Icons.logout_outlined, 'Log out', () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('token');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Are you sure ?',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          icon: const Icon(Icons.logout_outlined,
                              size: 30, color: Colors.red),
                          content: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel',
                                      style:
                                          TextStyle(color: Color(0xFF1CA4AC))),
                                ),
                                InkWell(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const Center(
                                        child: CircularProgressIndicator(
                                            color: Color(0xFF1CA4AC)),
                                      ),
                                    );
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
                                      color: const Color(0xFF1CA4AC),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
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
                  }, isLogout: true),
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
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 3,
            ),
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
                      MaterialPageRoute(builder: (context) => Dhomepage()));
                },
                child: const Icon(Icons.home_outlined, size: 30),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Amessage()));
                },
                child: const Icon(Icons.mail_outline, size: 30),
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

  Widget buildProfileItem(IconData icon, String title, VoidCallback onTap,
      {bool isLogout = false}) {
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
                child: Icon(icon, color: isLogout ? Colors.red : Colors.black),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isLogout ? Colors.red : Colors.black,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: InkWell(
                onTap: onTap,
                child: Icon(Icons.chevron_right_outlined,
                    size: 30, color: isLogout ? Colors.red : Colors.black),
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
