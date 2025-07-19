import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:merodoctor/api.dart'; // Your ApiConfig with URLs
import 'package:merodoctor/chatbotpage.dart';
import 'package:merodoctor/doctor/feedback.page.dart';
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
  File? _profileImageFile;
  String? profileImageUrl;
  String fullName = "Loading...";
  String gender = "";
  String address = "";
  String email = "";
  String phoneNumber = "";

  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchPatientDetails() async {
    final token = await _getToken();
    if (token == null) return;

    final url = Uri.parse(ApiConfig.fetchPatientOwnDetails);

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'];
          setState(() {
            fullName = data['fullName'] ?? "";
            profileImageUrl = data['profilePictureUrl'];
            gender = data['gender'] ?? "";
            address = data['address'] ?? "";
            email = data['email'] ?? "";
            phoneNumber = data['phoneNumber'] ?? "";
          });
        } else {
          print("Failed fetching patient data: ${jsonResponse['message']}");
        }
      } else {
        print('Error fetching patient details: ${response.body}');
      }
    } catch (e) {
      print('Exception fetching patient details: $e');
    }
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile == null) return;

    setState(() {
      _profileImageFile = File(pickedFile.path);
      isLoading = true;
    });

    final token = await _getToken();
    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url = Uri.parse(ApiConfig.imagelUrl);
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    // Attach the image file
    request.files.add(
        await http.MultipartFile.fromPath('file', _profileImageFile!.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          // Image uploaded successfully, update profileImageUrl and refresh details
          print("Image uploaded: ${jsonResponse['data']}");
          await _fetchPatientDetails();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Profile picture updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'] ?? 'Upload failed')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Upload failed with status ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildProfileImage() {
    ImageProvider imageProvider;
    if (_profileImageFile != null) {
      imageProvider = FileImage(_profileImageFile!);
    } else if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      if (profileImageUrl!.startsWith('http')) {
        imageProvider = NetworkImage(profileImageUrl!);
      } else {
        imageProvider = NetworkImage(ApiConfig.baseUrl + profileImageUrl!);
      }
    } else {
      imageProvider = const AssetImage('assets/image/startpage3.png');
    }
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.white,
          backgroundImage: imageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickAndUploadImage,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: isLoading
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: Colors.blue.shade900,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Icon(Icons.edit, size: 18, color: Colors.black),
            ),
          ),
        ),
      ],
    );
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
            _buildProfileImage(),

            const SizedBox(height: 15),
            Text(fullName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
            const SizedBox(height: 30),

            // Sex Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(height: 60, width: 1, color: Colors.white),
                Column(
                  children: [
                    const Text('Sex',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16)),
                    const SizedBox(height: 10),
                    Text(gender,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))
                  ],
                ),
                Container(height: 60, width: 1, color: Colors.white),
                Column(
                  children: [
                    const Text('Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16)),
                    const SizedBox(height: 10),
                    Text(email,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))
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
                    text: 'My Reports',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const Historyorsavedpage()));
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
                      icon: Icons.person_search_outlined,
                      text: 'Feedback',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FeedBackPage()));
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Homepage()));
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
