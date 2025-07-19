import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart';
import 'package:merodoctor/doctor/Dblog.dart';
import 'package:merodoctor/doctor/dprofilepage.dart';
import 'package:merodoctor/doctor/message.dart';
import 'package:merodoctor/doctor/patientrecord.dart';
import 'package:merodoctor/doctor/schedule.page.dart';
import 'package:merodoctor/reportcheck.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dhomepage extends StatefulWidget {
  const Dhomepage({super.key});

  @override
  State<Dhomepage> createState() => _DhomepageState();
}

class _DhomepageState extends State<Dhomepage> {
  String greeting = "";
  String doctorName = "";
  String? profilePictureUrl;
  List appointments = [];

  String? token;

  // Replace with your real backend base URL

  @override
  void initState() {
    super.initState();
    updateGreeting();
    _loadTokenAndFetchData();
  }

  void updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = "Good morning";
    } else if (hour < 17) {
      greeting = "Good afternoon";
    } else {
      greeting = "Good evening";
    }
  }

  Future<void> _loadTokenAndFetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token'); // Change key if needed

    if (savedToken == null || savedToken.isEmpty) {
      print("Token not found. Please login.");
      // You may want to navigate to login screen here
      return;
    }

    token = savedToken;

    await fetchDoctorDetails();
    await fetchAppointments();
  }

  Future<void> fetchDoctorDetails() async {
    if (token == null) return;

    final url = Uri.parse(ApiConfig.fetchDoctorOwnDetails);

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final data = jsonResponse['data'];
        print('Doctor Details response body: ${response.body}');
        setState(() {
          doctorName = data['fullName'] ?? "Doctor";
          profilePictureUrl = data['profilePictureUrl'];
        });
      } else {
        print('Failed to fetch doctor details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching doctor details: $e');
    }
  }

  Future<void> fetchAppointments() async {
    if (token == null) return;

    final url = Uri.parse(ApiConfig.doctorAppointments);

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final data = jsonResponse['data'] as List<dynamic>;
        setState(() {
          appointments = data;
        });
      } else {
        print('Failed to fetch appointments: ${response.body}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 65),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello Doctor',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$greeting, Dr. $doctorName',
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(93, 28, 165, 172),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(22),
                      ),
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    // Adjust height if needed or use flexible sizing
                    height: 710,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                'Welcome, \nDr. $doctorName',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(93, 28, 165, 172),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: profilePictureUrl != null
                                      ? Image.network(
                                          ApiConfig.baseUrl +
                                              profilePictureUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              Image.asset(
                                                  'assets/image/startpage3.png',
                                                  fit: BoxFit.cover),
                                        )
                                      : Image.asset(
                                          'assets/image/startpage3.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: 160,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(93, 28, 165, 172),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Todays Appointment',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${appointments.length}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            children: [
                              _iconCard(
                                  Icons.edit_document, 'Appointments', () {}),
                              const SizedBox(width: 9),
                              const SizedBox(width: 9),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScheudlePage()));
                                },
                                child: _iconCard(Icons.calendar_month_outlined,
                                    'Schedule', () {}),
                              ),
                              const SizedBox(width: 9),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Dblog()));
                                },
                                child:
                                    _iconCard(Icons.post_add, 'My Blog', () {}),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Appointments',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                        Expanded(
                          child: appointments.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text('No appointments found.'),
                                )
                              : SizedBox(
                                  height: 300, // adjust height as needed
                                  child: ListView.builder(
                                    itemCount: appointments.length,
                                    itemBuilder: (context, index) {
                                      final appointment = appointments[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Patientrecord()));
                                          },
                                          child: Container(
                                            height: 65,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: const Color(
                                                        0xFF1CA4AC)),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        appointment[
                                                                'patientName'] ??
                                                            'Unknown',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        appointment[
                                                                'availableTime'] ??
                                                            '--',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(appointment[
                                                              'status'] ??
                                                          'Unknown status'),
                                                      Text(appointment[
                                                              'availableDate'] ??
                                                          ''),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dmessage()));
                  },
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.black,
                    size: 33,
                  ),
                ),
              ),
            ],
          ),
        ),
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
              const Icon(
                Icons.calendar_month_outlined,
                size: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Dprofilepage()));
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

  Widget _iconCard(IconData icon, String label, VoidCallback onTap) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          color: const Color.fromARGB(93, 28, 165, 172),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
