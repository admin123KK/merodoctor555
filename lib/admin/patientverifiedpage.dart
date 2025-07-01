import 'package:flutter/material.dart';

class VerifiedPatientsPage extends StatefulWidget {
  const VerifiedPatientsPage({super.key});

  @override
  State<VerifiedPatientsPage> createState() => _VerifiedPatientsPageState();
}

class _VerifiedPatientsPageState extends State<VerifiedPatientsPage> {
  List<Map<String, dynamic>> patients = [
    {
      'name': 'Aakash Karki',
      'age': '30',
      'email': 'karkiaku@gmail.com',
      'active': true
    },
    {
      'name': 'Abiskar Gyawali',
      'age': '30',
      'email': 'abiskar@gmail.com',
      'active': false
    },
    {
      'name': 'Ritesh Ac',
      'age': '20',
      'email': 'ritesh@gmail.com',
      'active': true
    },
    {
      'name': 'Bishal Ghimire',
      'age': '22',
      'email': 'bishal@gmail.com',
      'active': true
    },
  ];

  void showPatientDetails(Map<String, dynamic> patient) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Verified Patient Record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${patient['name']}'),
            Text('Age: ${patient['age']}'),
            Text('Email: ${patient['email']}'),
            const Text('Status: Verified'),
            const Text('Appointment Time: Not Assigned'),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(
                  color: Color(0xFF1CA4AC), fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> verifiedPatients =
        patients.where((p) => p['active'] == true).toList();

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
                  child: Text('Verified Patients',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const Icon(Icons.verified, color: Colors.green, size: 30),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Text(
                  'Verified List',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text("Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
                Expanded(
                    flex: 2,
                    child: Text("Age",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
                Expanded(
                    flex: 2,
                    child: Text("Status",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: verifiedPatients.length,
              itemBuilder: (context, index) {
                final patient = verifiedPatients[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                          child: Row(
                            children: [
                              const Icon(Icons.verified, color: Colors.green),
                              const SizedBox(width: 5),
                              Text(patient['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Text(patient['age'],
                                style: const TextStyle(color: Colors.black87))),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "Verified",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showPatientDetails(patient);
                          },
                          child: Container(
                            height: 22,
                            width: 55,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1CA4AC),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text('View',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )
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
