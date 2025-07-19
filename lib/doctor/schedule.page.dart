import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorDetails {
  final String userId;
  final String fullName;
  final String? profilePictureUrl;
  final String registrationId;
  final String email;
  final String phoneNumber;
  final String status;
  final String degree;
  final int experience;
  final String clinicAddress;
  final String specializationName;
  final double latitude;
  final double longitude;

  DoctorDetails({
    required this.userId,
    required this.fullName,
    this.profilePictureUrl,
    required this.registrationId,
    required this.email,
    required this.phoneNumber,
    required this.status,
    required this.degree,
    required this.experience,
    required this.clinicAddress,
    required this.specializationName,
    required this.latitude,
    required this.longitude,
  });

  factory DoctorDetails.fromJson(Map<String, dynamic> json) {
    return DoctorDetails(
      userId: json['userId'],
      fullName: json['fullName'],
      profilePictureUrl: json['profilePictureUrl'],
      registrationId: json['registrationId'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      status: json['status'],
      degree: json['degree'],
      experience: json['experience'],
      clinicAddress: json['clinicAddress'],
      specializationName: json['specializationName'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class DoctorAvailability {
  final String doctorUserId;
  final List<AvailabilityDay> availabilities;

  DoctorAvailability(
      {required this.doctorUserId, required this.availabilities});

  factory DoctorAvailability.fromJson(Map<String, dynamic> json) {
    return DoctorAvailability(
      doctorUserId: json['doctorUserId'],
      availabilities: (json['availabilities'] as List)
          .map((e) => AvailabilityDay.fromJson(e))
          .toList(),
    );
  }
}

class AvailabilityDay {
  final int doctorWeeklyAvailabilityId;
  final String dayOfWeek;
  final String availableDate;
  final List<TimeRange> timeRanges;

  AvailabilityDay({
    required this.doctorWeeklyAvailabilityId,
    required this.dayOfWeek,
    required this.availableDate,
    required this.timeRanges,
  });

  factory AvailabilityDay.fromJson(Map<String, dynamic> json) {
    return AvailabilityDay(
      doctorWeeklyAvailabilityId: json['doctorWeeklyAvailabilityId'],
      dayOfWeek: json['dayOfWeek'],
      availableDate: json['availableDate'],
      timeRanges: (json['timeRanges'] as List)
          .map((e) => TimeRange.fromJson(e))
          .toList(),
    );
  }
}

class TimeRange {
  final int timeRangeId;
  final String availableTime;
  final String isAvailable;

  TimeRange({
    required this.timeRangeId,
    required this.availableTime,
    required this.isAvailable,
  });

  factory TimeRange.fromJson(Map<String, dynamic> json) {
    return TimeRange(
      timeRangeId: json['timeRangeId'],
      availableTime: json['availableTime'],
      isAvailable: json['isAvailable'],
    );
  }
}

class ScheudlePage extends StatefulWidget {
  const ScheudlePage({Key? key}) : super(key: key);

  @override
  State<ScheudlePage> createState() => _ScheudlePageState();
}

class _ScheudlePageState extends State<ScheudlePage> {
  DoctorDetails? doctor;
  DoctorAvailability? availability;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDoctorAndAvailability();
  }

  Future<String?> _token() async {
    return (await SharedPreferences.getInstance()).getString('token');
  }

  Future<void> _showMessageDialog(String title, String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK")),
        ],
      ),
    );
  }

  Future<void> loadDoctorAndAvailability() async {
    final token = await _token();
    if (token == null) {
      setState(() {
        loading = false;
      });
      return;
    }
    try {
      final doctorResp = await http.get(
          Uri.parse(ApiConfig.fetchDoctorOwnDetails),
          headers: {"Authorization": "Bearer $token"});
      if (doctorResp.statusCode == 200 && doctorResp.body.isNotEmpty) {
        final doctorJson = jsonDecode(doctorResp.body);
        doctor = DoctorDetails.fromJson(doctorJson['data']);

        final availResp = await http.get(
          Uri.parse(ApiConfig.getAvailability(doctor!.userId)),
          headers: {"Authorization": "Bearer $token"},
        );
        if (availResp.statusCode == 200 && availResp.body.isNotEmpty) {
          final availJson = jsonDecode(availResp.body);
          availability = DoctorAvailability.fromJson(availJson['data']);
        } else {
          availability = null;
        }
      } else {
        doctor = null;
      }
    } catch (_) {
      doctor = null;
      availability = null;
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> deleteDaySchedule(int doctorWeeklyAvailabilityId) async {
    final token = await _token();
    if (token == null) return;

    final resp = await http.delete(
      Uri.parse(ApiConfig.deleteDaySchedule),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(
          {"doctorWeeklyAvailabilityId": doctorWeeklyAvailabilityId}),
    );

    try {
      if (resp.body.isEmpty) {
        await _showMessageDialog("Error", "No response from server.");
        return;
      }

      final data = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        await loadDoctorAndAvailability();
        await _showMessageDialog(
            "Success", data['message'] ?? "Deleted successfully.");
      } else {
        await _showMessageDialog(
            "Error", data['message'] ?? "Failed to delete day schedule.");
      }
    } catch (e) {
      await _showMessageDialog("Error", "Unknown error occurred");
    }
  }

  Future<void> deleteTimeRange(int timeRangeId) async {
    final token = await _token();
    if (token == null) return;

    final resp = await http.delete(
      Uri.parse(ApiConfig.deleteTimeRange),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"timeRangeId": timeRangeId}),
    );

    try {
      if (resp.body.isEmpty) {
        await _showMessageDialog("Error", "No response from server.");
        return;
      }

      final data = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        await loadDoctorAndAvailability();
        await _showMessageDialog(
            "Success", data['message'] ?? "Deleted successfully.");
      } else {
        await _showMessageDialog(
            "Error", data['message'] ?? "Failed to delete time range.");
      }
    } catch (e) {
      await _showMessageDialog("Error", "Unknown error occurred");
    }
  }

  Future<void> _showAddAvailabilitySheet() async {
    DateTime? selectedDate;
    List<TimeOfDay> timeRanges = [];

    final _formKey = GlobalKey<FormState>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Add Availability",
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 20),

                        // Date picker
                        Row(
                          children: [
                            Expanded(
                              child: Text(selectedDate == null
                                  ? "No date selected"
                                  : DateFormat('yyyy-MM-dd')
                                      .format(selectedDate!)),
                            ),
                            TextButton(
                              child: const Text("Pick Date"),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setModalState(() {
                                    selectedDate = date;
                                  });
                                }
                              },
                            )
                          ],
                        ),

                        // Time ranges list
                        ...timeRanges
                            .map((t) => ListTile(
                                  title: Text(t.format(context)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.red),
                                    onPressed: () {
                                      setModalState(() {
                                        timeRanges.remove(t);
                                      });
                                    },
                                  ),
                                ))
                            .toList(),

                        TextButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: const Text("Add Time"),
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setModalState(() {
                                if (!timeRanges.contains(time)) {
                                  timeRanges.add(time);
                                  timeRanges.sort((a, b) {
                                    final aMins = a.hour * 60 + a.minute;
                                    final bMins = b.hour * 60 + b.minute;
                                    return aMins.compareTo(bMins);
                                  });
                                }
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        ElevatedButton(
                          onPressed: (selectedDate != null &&
                                  timeRanges.isNotEmpty)
                              ? () async {
                                  List<Map<String, String>> timeRangeMaps =
                                      timeRanges.map((t) {
                                    // Convert TimeOfDay to HH:mm:ss for C# backend
                                    String timeString =
                                        "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00";
                                    return {"availableTime": timeString};
                                  }).toList();

                                  final postBody = {
                                    "availabilities": [
                                      {
                                        "availableDate":
                                            DateFormat('yyyy-MM-dd')
                                                .format(selectedDate!),
                                        "timeRanges": timeRangeMaps,
                                      }
                                    ]
                                  };

                                  final token = await _token();
                                  if (token == null) {
                                    _showMessageDialog(
                                        "Error", "Authorization failed.");
                                    return;
                                  }

                                  setModalState(() {
                                    loading = true;
                                  });

                                  try {
                                    final response = await http.post(
                                      Uri.parse(ApiConfig.setAvailability),
                                      headers: {
                                        "Authorization": "Bearer $token",
                                        "Content-Type": "application/json",
                                      },
                                      body: jsonEncode(postBody),
                                    );

                                    if (response.body.isEmpty) {
                                      await _showMessageDialog(
                                          "Error", "No response from server.");
                                      return;
                                    }

                                    final data = jsonDecode(response.body);

                                    if (response.statusCode == 200) {
                                      Navigator.of(context)
                                          .pop(); // Close modal
                                      await loadDoctorAndAvailability();
                                      await _showMessageDialog(
                                          "Success",
                                          data['message'] ??
                                              "Availability added successfully.");
                                    } else {
                                      await _showMessageDialog(
                                          "Error",
                                          data['message'] ??
                                              "Failed to add availability.");
                                    }
                                  } catch (e) {
                                    await _showMessageDialog(
                                        "Error", "Error: $e");
                                  }

                                  setModalState(() {
                                    loading = false;
                                  });
                                }
                              : null,
                          child: const Text("Submit Availability"),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _confirmDeleteDay(int doctorWeeklyAvailabilityId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Day Schedule"),
        content: const Text(
            "Are you sure you want to delete this entire day's schedule?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteDaySchedule(doctorWeeklyAvailabilityId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTimeRange(int timeRangeId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Time Range"),
        content: const Text("Are you sure you want to delete this time range?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteTimeRange(timeRangeId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (doctor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Doctor Schedule")),
        body: const Center(child: Text("Failed to load doctor details.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Dr. ${doctor!.fullName} Schedule")),
      body: availability == null || availability!.availabilities.isEmpty
          ? const Center(child: Text("No availability set."))
          : ListView.builder(
              itemCount: availability!.availabilities.length,
              itemBuilder: (context, index) {
                final day = availability!.availabilities[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          "${day.dayOfWeek} (${day.availableDate})",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete_forever,
                              color: Colors.red),
                          onPressed: () {
                            _confirmDeleteDay(day.doctorWeeklyAvailabilityId);
                          },
                          tooltip: "Delete entire day schedule",
                        ),
                      ],
                    ),
                    children: day.timeRanges.map((timeRange) {
                      return ListTile(
                        title: Text(timeRange.availableTime),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDeleteTimeRange(timeRange.timeRangeId);
                          },
                          tooltip: "Delete this time range",
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _showAddAvailabilitySheet,
        tooltip: 'Add availability',
      ),
    );
  }
}
