import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingPatientsPage extends StatefulWidget {
  const PendingPatientsPage({super.key});

  @override
  State<PendingPatientsPage> createState() => _PendingPatientsPageState();
}

class _PendingPatientsPageState extends State<PendingPatientsPage> {
  List<Map<String, dynamic>> pendingDoctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPendingDoctors();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchPendingDoctors() async {
    final token = await getToken();
    if (token == null) return;

    final url = Uri.parse(ApiConfig.pendingDoctors);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      setState(() {
        pendingDoctors = data
            .where((doc) => doc['status'].toString().toLowerCase() == 'pending')
            .map<Map<String, dynamic>>((doc) => {
                  'doctorId': doc['doctorId'],
                  'fullName': doc['fullName'],
                  'email': doc['email'],
                  'phoneNumber': doc['phoneNumber'],
                  'degree': doc['degree'],
                  'experience': doc['experience'],
                  'registrationId': doc['registrationId'],
                  'clinicAddress': doc['clinicAddress'],
                  'specialization': doc['specialization'],
                  'status': doc['status'],
                })
            .toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load pending doctors')),
      );
    }
  }

  Future<void> updateDoctorStatus(int doctorId, String status) async {
    final token = await getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication token missing')),
      );
      return;
    }

    // Map to enum int: Pending=0, Verified=1, Rejected=2
    final int statusInt = status.toLowerCase() == 'verified'
        ? 1
        : status.toLowerCase() == 'rejected'
            ? 2
            : 0;

    final url = Uri.parse(ApiConfig.updateDoctorStatusUrl(doctorId.toString()));

    final res = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(statusInt), // <-- just 1 or 2, no wrapper object
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Doctor status updated to "$status" successfully'),
        backgroundColor: Colors.green,
      ));
      await fetchPendingDoctors();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update: ${res.statusCode}'),
        backgroundColor: Colors.red,
      ));
    }
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
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_new_outlined,
                            size: 27),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Text('Pending Doctors',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.hourglass_top,
                          color: Colors.orange, size: 30),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Text('Pending List',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: pendingDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = pendingDoctors[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name: ${doctor['fullName']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text("Email: ${doctor['email']}"),
                                Text("Phone: ${doctor['phoneNumber']}"),
                                Text("Degree: ${doctor['degree']}"),
                                Text(
                                    "Experience: ${doctor['experience']} years"),
                                Text(
                                    "Registration ID: ${doctor['registrationId']}"),
                                Text(
                                    "Clinic Address: ${doctor['clinicAddress']}"),
                                Text(
                                    "Specialization: ${doctor['specialization']}"),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Status: ${doctor['status']}",
                                        style: const TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => updateDoctorStatus(
                                              doctor['doctorId'], 'Verified'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            minimumSize: const Size(50, 35),
                                          ),
                                          child: const Text("Verify",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () => updateDoctorStatus(
                                              doctor['doctorId'], 'Rejected'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            minimumSize: const Size(50, 35),
                                          ),
                                          child: const Text("Reject",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
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
    );
  }
}
