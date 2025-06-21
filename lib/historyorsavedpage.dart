import 'package:flutter/material.dart';

class Historyorsavedpage extends StatefulWidget {
  const Historyorsavedpage({super.key});

  @override
  State<Historyorsavedpage> createState() => _HistoryorsavedpageState();
}

class _HistoryorsavedpageState extends State<Historyorsavedpage> {
  final List<Map<String, dynamic>> patients = [
    {
      'name': 'Joe Ramg',
      'age': 28,
      "id": 'ETH101',
      'image': 'assets/image/startpage1.png'
    },
    {
      'name': 'Joe Ramg',
      'age': 28,
      "id": 'ETH101',
      'image': 'assets/image/startpage1.png'
    },
    {
      'name': 'Joe Ramg',
      'age': 28,
      "id": 'ETH101',
      'image': 'assets/image/startpage1.png'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 30),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'History',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        const Icon(Icons.more_vert, size: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(93, 28, 165, 172),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 4)
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            patient['image'],
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 20), // FIXED: horizontal space
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patient['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text('Age: ${patient['age']}'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Patient ID: ${patient['id']}'),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Patient Report',
                                              ),
                                              actions: [
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          patient['name'],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                            'ID: ${patient['id']}'),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            'Age: ${patient['age']}'),
                                                        Text('Referring Doctor')
                                                      ],
                                                    ),
                                                    const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            'Date: 1977/20/21'),
                                                        const Text(
                                                            'Dr.Abiskar G')
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          height: 90,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14),
                                                              color:
                                                                  Colors.grey),
                                                          child: Image.asset(
                                                            'assets/image/xray.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const Text(
                                                            'Apr 27, 2025')
                                                      ],
                                                    ),
                                                    const Column(
                                                      children: [
                                                        Text(
                                                          'PNEUMONIA \nDETECTED',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 27),
                                                        ),
                                                        Text(
                                                            'Confidence:   98%'),
                                                        Text(
                                                            'Severity: Moderate')
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Row(
                                                  children: [
                                                    Text(
                                                      "Doctor's Remarks",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                                const Row(
                                                  children: [
                                                    Text(
                                                        'Pneumonia detected. Antibiotics prescribed. \nRest, fluids, and follow-up in 3–5 days \nrecommended. Seek care if symptoms worsen.')
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                const Row(
                                                  children: [
                                                    Text(
                                                      'Prescription',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    )
                                                  ],
                                                ),
                                                const Row(
                                                  children: [
                                                    Text(
                                                        'Tab Azithromycin 500mg – 1 tablet once \ndaily for 5 days'),
                                                  ],
                                                ),
                                                const Row(
                                                  children: [
                                                    Text(
                                                        'Follow-up: May 5,2024')
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '© 2024 AI generated report diagonosis by\n licensed medical professional.',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Text(
                                                      'OK',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color: Color(
                                                              0xFF1CA4AC)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius:
                                              BorderRadius.circular(17)),
                                      child: const Center(
                                          child: Text(
                                        'Details',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
