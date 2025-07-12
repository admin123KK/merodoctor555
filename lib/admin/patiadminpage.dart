import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Patient {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final String address;
  final double latitude;
  final double longitude;

  Patient({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      address: json['address'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class PAdminPage extends StatefulWidget {
  const PAdminPage({super.key});

  @override
  State<PAdminPage> createState() => _PAdminPageState();
}

class _PAdminPageState extends State<PAdminPage> {
  List<Patient> patients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchPatients() async {
    setState(() {
      isLoading = true;
    });

    final token = await getToken();
    if (token == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Auth token missing')));
      setState(() => isLoading = false);
      return;
    }

    final url = Uri.parse(ApiConfig.getAllPatients); // Define this in ApiConfig
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      setState(() {
        patients = data.map((json) => Patient.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to load patients: ${response.statusCode}')));
    }
  }

  void showPatientDetails(Patient patient) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Patient Record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${patient.fullName}'),
            Text('Email: ${patient.email}'),
            Text('Phone: ${patient.phoneNumber}'),
            Text('Gender: ${patient.gender}'),
            Text('Date of Birth: ${patient.dateOfBirth}'),
            Text('Address: ${patient.address}'),
            Text(
                'Location: (${patient.latitude.toStringAsFixed(5)}, ${patient.longitude.toStringAsFixed(5)})'),
            const Text('Status: Active'),
          ],
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'OK',
                style: TextStyle(
                    color: Color(0xFF1CA4AC), fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.black,
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Text(
                          'Manage Patients',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      const Icon(
                        Icons.more_vert_outlined,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12)),
                    child: const TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded),
                          hintText: 'Search...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black45)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text("Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      Expanded(
                          flex: 2,
                          child: Text("Email",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      Expanded(
                          flex: 2,
                          child: Text("Phone",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      Expanded(
                          flex: 1,
                          child: Text("Status",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      Expanded(
                          flex: 1,
                          child: SizedBox()), // For "View" button space
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final p = patients[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 6),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(p.fullName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ),
                              Expanded(flex: 2, child: Text(p.email)),
                              Expanded(flex: 2, child: Text(p.phoneNumber)),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Active',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () => showPatientDetails(p),
                                  child: Container(
                                    height: 30,
                                    width: 55,
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1CA4AC),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'View',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
