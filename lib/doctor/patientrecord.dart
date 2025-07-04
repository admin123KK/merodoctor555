import 'package:flutter/material.dart';

class Patientrecord extends StatefulWidget {
  const Patientrecord({super.key});

  @override
  State<Patientrecord> createState() => _PatientrecordState();
}

class _PatientrecordState extends State<Patientrecord> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 25, color: Colors.black)),
                  const SizedBox(
                    width: 20,
                  ),
                  const Expanded(
                    child: const Text(
                      'Patient Record',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  const Icon(Icons.more_vert_rounded,
                      size: 25, color: Colors.black),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(93, 28, 165, 172),
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: Image.asset('assets/image/startpage3.png'),
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Sapana Karki',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text('Age: 17'),
                        Text('Blood Group: A+'),
                      ],
                    )
                  ],
                ),
              ),
            ),

            // Tab Bar
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Color(0xFF1CA4AC),
              tabs: [
                Tab(text: 'Overview'),
                Tab(text: 'Appointments'),
              ],
            ),
            // TabBar View
            const Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Text('Vitals, Allergies, Diagnosis...'),
                  ),
                  Center(child: Text('Upcoming and past appointments.')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
