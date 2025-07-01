import 'package:flutter/material.dart';

class PendingDoctorsPage extends StatelessWidget {
  const PendingDoctorsPage({super.key});

  final List<String> pendingDoctorNames = const [
    'Dr. Nirajan Bista',
    'Dr. Bina Thapa',
    'Dr. Subash Gautam',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new_outlined,
                      size: 27, color: Colors.black),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Text('Pending Doctor',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const Icon(Icons.hourglass_top, color: Colors.orange, size: 30),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Text(
                  'Pending Doctor List',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: pendingDoctorNames.length,
              itemBuilder: (context, index) {
                final doctorName = pendingDoctorNames[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.orange.shade50,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.hourglass_top, color: Colors.orange),
                        const SizedBox(width: 12),
                        Text(
                          doctorName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
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
