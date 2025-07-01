import 'package:flutter/material.dart';

class RejectedDoctorsPage extends StatelessWidget {
  const RejectedDoctorsPage({super.key});

  final List<String> rejectedDoctorNames = const [
    'Dr. Abiskar Gyawali',
    'Dr. Ritesh Ac',
    'Dr. Sushma Sharma',
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
                  child: Text('Rejected Doctor',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const Icon(Icons.cancel_outlined, color: Colors.red, size: 30),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Text(
                  'Rejected Doctor List',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: rejectedDoctorNames.length,
              itemBuilder: (context, index) {
                final doctorName = rejectedDoctorNames[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red.shade50,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cancel_outlined, color: Colors.red),
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
