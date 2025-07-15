import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/admin/adminprofile.dart';
import 'package:merodoctor/admin/amessage.dart';
import 'package:merodoctor/admin/feebackspage.dart';
import 'package:merodoctor/admin/patiadminpage.dart';
import 'package:merodoctor/admin/specializedpage.dart';
import 'package:merodoctor/admin/totalblogpage.dart';
import 'package:merodoctor/api.dart' as api_config;
import 'package:merodoctor/doctor/doctorrejectepage.dart';
import 'package:merodoctor/doctor/doctorverifiedpage.dart';
import 'package:merodoctor/doctor/drpendingpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ahomepage extends StatefulWidget {
  const Ahomepage({super.key});

  @override
  State<Ahomepage> createState() => _AhomepageState();
}

class _AhomepageState extends State<Ahomepage> {
  String greeting = "";
  String fullName = "";
  int totalDoctors = 0;
  int totalPatients = 0;
  int totalAppointments = 0;
  int totalPneumonia = 0;
  int totalBlogs = 0;

  @override
  void initState() {
    super.initState();
    updateGreeting();
    fetchDashboardStats();
    fetchUserProfile();
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

  Future<void> fetchDashboardStats() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final url = Uri.parse(api_config.ApiConfig.adminDashbordeUrl);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        print('Data: ${response.body}');
        setState(() {
          totalDoctors = data['totalDoctors'];
          totalPatients = data['totalPatients'];
          totalAppointments = data['totalAppointments'];
          totalPneumonia = data['totalPneumoniaChecked'];
          totalBlogs = data['totaDoctorlBlogs'];
        });
      } else {
        print('Stats Error: ${response.body}');
      }
    } catch (e) {
      print('Error fetching dashboard stats: $e');
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final url = Uri.parse(api_config.ApiConfig.adminProfileUrl);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          fullName = data['fullName'];
        });
      } else {
        print('Profile Error: ${response.body}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Mero Doctor',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                  '$greeting, ${fullName.isNotEmpty ? fullName : 'Admin'}'),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text('Admin Panel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        statBox(
                          'Total\nPatients',
                          totalPatients,
                        ),
                        statBox('Total\nDoctors', totalDoctors),
                        statBox('Appointments', totalAppointments, width: 130),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        statBox('Total\nPneumonia', totalPneumonia, width: 170),
                        statBox('Total\nBlog', totalBlogs, width: 170),
                      ],
                    ),
                    const SizedBox(height: 20),
                    navTile('Patients', 'VIEW', () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PAdminPage()));
                    }),
                    navTile('Verified Doctors', 'VIEW', () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VerifiedDoctorsPage()));
                    }),
                    navTile('Rejected Doctors', 'VIEW', () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RejectedDoctorsPage()));
                    }),
                    navTile('Pending Doctors', 'VIEW', () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PendingPatientsPage()));
                    }),
                    navTile('Manage Specilization', 'VIEW', () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SpecializationAdminPage()));
                    }),
                    navTile('Manage Categories', 'VIEW', () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BlogCategoryAdminPage()));
                    }),
                    navTile('View Feebacks', 'VIEW', () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FeedbacksPage()));
                    }),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text('Notifications',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget statBox(String label, int count, {double width = 100}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 130,
        width: width,
        decoration: BoxDecoration(
            color: const Color.fromARGB(93, 28, 165, 172),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.bar_chart_outlined, size: 30),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('$count',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          ],
        ),
      ),
    );
  }

  Widget navTile(String title, String buttonText, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: const Color.fromARGB(93, 28, 165, 172),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
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
                            ),
                          ));
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.pop(context);
                  onTap();
                },
                child: Container(
                  height: 30,
                  width: 60,
                  decoration: BoxDecoration(
                      color: const Color(0xFF1CA4AC),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(buttonText,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget BottomNavBar() {
    return Container(
      height: 90,
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
              offset: const Offset(0, 2),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.home_outlined, size: 30, color: Color(0xFF1CA4AC)),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Amessage()));
              },
              child: const Icon(Icons.mail_outline, size: 30),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Adminprofile()));
              },
              child: const Icon(Icons.person_outline_rounded, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
