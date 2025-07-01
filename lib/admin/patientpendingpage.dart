import 'package:flutter/material.dart';

class PendingPatientsPage extends StatefulWidget {
  const PendingPatientsPage({super.key});

  @override
  State<PendingPatientsPage> createState() => _PendingPatientsPageState();
}

class _PendingPatientsPageState extends State<PendingPatientsPage> {
  List<Map<String, dynamic>> patients = [
    {
      'name': 'Aakash Karki',
      'age': '30',
      'email': 'karkiaku@gmail.com',
      'status': 'verified'
    },
    {
      'name': 'Abiskar Gyawali',
      'age': '30',
      'email': 'abiskar@gmail.com',
      'status': 'rejected'
    },
    {
      'name': 'Ritesh Ac',
      'age': '20',
      'email': 'ritesh@gmail.com',
      'status': 'pending'
    },
    {
      'name': 'Bishal Ghimire',
      'age': '22',
      'email': 'bishal@gmail.com',
      'status': 'pending'
    },
  ];

  void showPatientDetails(Map<String, dynamic> patient) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pending Patient Record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${patient['name']}'),
            Text('Age: ${patient['age']}'),
            Text('Email: ${patient['email']}'),
            const Text('Status: Pending Verification'),
            const Text('Appointment Time: Not Assigned'),
          ],
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.pop(context),
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
    List<Map<String, dynamic>> pendingPatients =
        patients.where((p) => p['status'] == 'pending').toList();

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
                  child: Text('Pending Patients',
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
                  'Pending List',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
              itemCount: pendingPatients.length,
              itemBuilder: (context, index) {
                final patient = pendingPatients[index];
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
                              const Icon(Icons.hourglass_top,
                                  color: Colors.orange),
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
                              "Pending",
                              style: TextStyle(
                                  color: Colors.orange,
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
                              color: Colors.orange.shade300,
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
