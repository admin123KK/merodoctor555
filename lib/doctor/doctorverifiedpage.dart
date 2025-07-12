import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorInfo {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String degree;
  final int experience;
  final String registrationId;
  final String clinicAddress;
  final String specialization;
  final String status;

  DoctorInfo({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.degree,
    required this.experience,
    required this.registrationId,
    required this.clinicAddress,
    required this.specialization,
    required this.status,
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) => DoctorInfo(
        id: json['doctorId'],
        fullName: json['fullName'],
        email: json['email'],
        phone: json['phoneNumber'],
        degree: json['degree'],
        experience: json['experience'],
        registrationId: json['registrationId'],
        clinicAddress: json['clinicAddress'],
        specialization: json['specialization'],
        status: json['status'],
      );
}

class VerifiedDoctorsPage extends StatefulWidget {
  const VerifiedDoctorsPage({Key? key}) : super(key: key);

  @override
  State<VerifiedDoctorsPage> createState() => _VerifiedDoctorsPageState();
}

class _VerifiedDoctorsPageState extends State<VerifiedDoctorsPage> {
  List<DoctorInfo> _docs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);

    final tok = await _token();
    if (tok == null) {
      _snack('Auth token missing');
      setState(() => _loading = false);
      return;
    }

    final res = await http.get(
      Uri.parse(ApiConfig.verifiedDoctors),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tok',
      },
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      final list = decoded['data'] as List<dynamic>;
      setState(() {
        _docs = list.map((e) => DoctorInfo.fromJson(e)).toList();
        _loading = false;
      });
    } else {
      _snack('Failed to load (${res.statusCode})');
      setState(() => _loading = false);
    }
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetch,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new_outlined,
                              size: 27),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: Text('Verified Doctors',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const Icon(Icons.verified,
                            color: Colors.green, size: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Text('Verified Doctor List',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 23)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _docs.length,
                      itemBuilder: (context, i) {
                        final d = _docs[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          child: Card(
                            color: Colors.green.shade50,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: Colors.green.shade200, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.verified,
                                          color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(d.fullName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text('Email: ${d.email}'),
                                  Text('Phone: ${d.phone}'),
                                  Text('Degree: ${d.degree}'),
                                  Text('Experience: ${d.experience} yrs'),
                                  Text('Reg. ID: ${d.registrationId}'),
                                  Text('Clinic: ${d.clinicAddress}'),
                                  Text('Specialization: ${d.specialization}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
