import 'package:flutter/material.dart';

class DAdminPage extends StatefulWidget {
  const DAdminPage({super.key});

  @override
  State<DAdminPage> createState() => _DAdminPageState();
}

class _DAdminPageState extends State<DAdminPage> {
  List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. John Smith',
      'specialty': 'Cardiologist',
      'email': 'john@example.com',
      'verified': true,
    },
    {
      'name': 'Dr. Jane Doe',
      'specialty': 'Dermatologist',
      'email': 'jane@example.com',
      'verified': true,
    },
    {
      'name': 'Dr. Michael Brown',
      'specialty': 'Orthopedist',
      'email': 'michael@example.com',
      'verified': false,
    },
    {
      'name': 'Dr. Emily Wilson',
      'specialty': 'Pediatrician',
      'email': 'emily@example.com',
      'verified': false,
    },
  ];

  void showVerifyDialog(int index) {
    String nmcId = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Verify Doctor'),
        content: TextField(
          onChanged: (value) {
            nmcId = value;
          },
          decoration: const InputDecoration(
            labelText: 'NMC ID',
            hintText: 'Enter NMC ID',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                doctors[index]['verified'] = true;
              });
              Navigator.pop(context);
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void showViewDialoge() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.black,
                        size: 27,
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  const Expanded(
                    child: const Text(
                      'Manage Doctors',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const Icon(Icons.more_vert_outlined, size: 30),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  const Text(
                    'Doctor List',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Header
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: const [
                  Expanded(
                      flex: 3,
                      child: Text("Name",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 3,
                      child: Text("Specialty",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text("Status",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Doctor List
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text(doctor['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600))),
                          Expanded(flex: 3, child: Text(doctor['specialty'])),
                          Expanded(
                            flex: 2,
                            child: doctor['verified']
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6F4EA),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Verified",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    onPressed: () => showVerifyDialog(index),
                                    child: const Text("Verify"),
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
      ),
    );
  }
}
