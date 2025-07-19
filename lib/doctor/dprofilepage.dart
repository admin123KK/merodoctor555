import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:merodoctor/api.dart';
import 'package:merodoctor/chatbotpage.dart';
import 'package:merodoctor/doctor/dhomepage.dart';
import 'package:merodoctor/doctor/feedback.page.dart';
import 'package:merodoctor/historyorsavedpage.dart';
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
  Map<String, dynamic>? doctorData;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      await _uploadProfileImage(_profileImage!);
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConfig.imagelUrl),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      await fetchDoctorDetails(); // Refresh profile data
    } else {
      print('Image upload failed: ${response.statusCode}');
    }
  }

  Future<void> fetchDoctorDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(ApiConfig.fetchDoctorOwnDetails),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        doctorData = json['data'];
      });
    } else {
      print('Failed to fetch doctor details: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  @override
  Widget build(BuildContext context) {
    // Prepare profile image provider safely
    ImageProvider<Object> profileImageProvider;

    if (_profileImage != null) {
      // Use locally picked image
      profileImageProvider = FileImage(_profileImage!);
    } else if (doctorData != null && doctorData!['profilePictureUrl'] != null) {
      String profilePic = doctorData!['profilePictureUrl'];
      if (profilePic.startsWith('file://')) {
        // Convert local file URI to FileImage
        String filePath = profilePic.replaceFirst('file://', '');
        profileImageProvider = FileImage(File(filePath));
      } else if (profilePic.startsWith('http') ||
          profilePic.startsWith('https')) {
        // Absolute URL, use NetworkImage
        profileImageProvider = NetworkImage(profilePic);
      } else {
        // Relative path, prepend baseUrl
        profileImageProvider = NetworkImage(ApiConfig.baseUrl + profilePic);
      }
    } else {
      // Default asset image fallback
      profileImageProvider = const AssetImage('assets/image/startpage3.png');
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1CA4AC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 70),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Dhomepage()));
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
                  const Icon(Icons.more_vert, size: 26, color: Colors.white),
                ],
              ),
            ),

            // Profile image with edit icon
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  backgroundImage: profileImageProvider,
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
                      child: const Icon(Icons.edit, size: 20),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            Text(
              doctorData != null && doctorData!['fullName'] != null
                  ? doctorData!['fullName']
                  : 'Dr.Sky Karki',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const SizedBox(height: 10),
            // Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 60,
                  width: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      doctorData != null && doctorData!['email'] != null
                          ? doctorData!['email']
                          : 'Male',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                  height: 60,
                  width: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      'RegistrationId',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      doctorData != null &&
                              doctorData!['registrationId'] != null
                          ? doctorData!['registrationId'].toString()
                          : '27',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  height: 60,
                  width: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            _bottomContainer(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _bottomContainer() {
    return Container(
      height: 550,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      child: Column(
        children: [
          _optionRow(Icons.favorite_outline, "Patient Record", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Historyorsavedpage()));
          }),
          _divider(),
          _optionRow(Icons.qr_code_rounded, "Report Check", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Reportcheck()));
          }),
          _divider(),
          _optionRow(Icons.person_search_outlined, "Appointment", () {}),
          _divider(),
          _optionRow(Icons.settings_outlined, "Settings", () {}),
          _divider(),
          _optionRow(Icons.message_outlined, "FAQs", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Chatbotpage()));
          }),
          _divider(),
          _optionRow(Icons.settings_outlined, "Feedback", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FeedBackPage()));
          }),
          _divider(),
          _optionRow(Icons.settings_outlined, "Settings", () {}),
          _divider(),
          _optionRow(Icons.logout_outlined, "Log out", _logout,
              iconColor: Colors.red, textColor: Colors.red),
          _divider(),
        ],
      ),
    );
  }

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Divider(),
      );

  Widget _optionRow(IconData icon, String title, VoidCallback onTap,
      {Color iconColor = Colors.black, Color textColor = Colors.black}) {
    return Row(
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
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: InkWell(
            onTap: onTap,
            child:
                Icon(Icons.chevron_right_outlined, size: 30, color: textColor),
          ),
        ),
      ],
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(color: Color(0xFF1CA4AC)),
            ));
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Loginpage()));
  }

  Widget _bottomNavBar() {
    return Container(
      height: 90,
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
                      MaterialPageRoute(builder: (context) => Dhomepage()));
                },
                child: const Icon(Icons.home_outlined, size: 30)),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Reportcheck()));
              },
              child: const Icon(Icons.qr_code_scanner_rounded, size: 30),
            ),
            const Icon(Icons.calendar_month_outlined, size: 30),
            const Icon(Icons.person_outline,
                color: Color(0xFF1CA4AC), size: 30),
          ],
        ),
      ),
    );
  }
}
