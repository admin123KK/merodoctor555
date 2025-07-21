import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<dynamic> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final url = Uri.parse(ApiConfig.getUpcommingAppointments);

    try {
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
        // Add authorization if needed
      });

      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          appointments = data['data'];
          isLoading = false;
        });
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void bookAppointment(int appointmentId) {
    // You can call a booking API here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking appointment ID: $appointmentId')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upcoming Appointments')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : appointments.isEmpty
              ? const Center(child: Text('No upcoming appointments found.'))
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            "none", // You can modify to dynamic
                          ),
                        ),
                        title: Text(appointment['doctorName']),
                        subtitle: Text(
                          '${appointment['availableDate']} at ${appointment['availableTime']}',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () =>
                              bookAppointment(appointment['appointmentId']),
                          child: const Text('Book'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
