import 'dart:ffi';
import 'package:flutter/material.dart';

class PAdminPage extends StatefulWidget {
  const PAdminPage({super.key});

  @override
  State<PAdminPage> createState() => _PAdminPageState();
}

class _PAdminPageState extends State<PAdminPage> {
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
      'name': 'Aakash Karki',
      'age': '20',
      'email': 'karkiaku@gmail.com',
      'active': true
    },
    {
      'name': 'Abiskar Gyawali',
      'age': '20',
      'email': 'abiskar@gmail.com',
      'active': false
    },
  ];

  void showPatientDetails() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Patient Record'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Age :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Email :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Status :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Appointment Time :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                  color: Color(
                    0xFF1CA4AC,
                  ),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                const SizedBox(
                  width: 20,
                ),
                const Expanded(
                  child: const Text(
                    'Manage Patient',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const Icon(
                  Icons.more_vert_outlined,
                  size: 30,
                )
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
                Text(
                  'Patient List',
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
                    flex: 2,
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
          // Patient List
          Expanded(
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
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
                            child: Text(patient['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600))),
                        Expanded(flex: 2, child: Text(patient['age'])),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            // decoration: BoxDecoration(
                            //   color: patient['active']
                            //       ? Color(0xFFE6F4EA)
                            //       : Color(0xFFFFE6E6),
                            //   borderRadius: BorderRadius.circular(20),
                            // ),
                            child: Text(
                              patient['active'] ? 'Active' : "Inactive",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: patient['active']
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              showPatientDetails();
                            },
                            child: Container(
                              height: 20,
                              width: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1CA4AC),
                                borderRadius: BorderRadius.circular(17),
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
