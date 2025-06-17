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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 30),
                  ),
                  const Text(
                    'History',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const Icon(Icons.more_vert, size: 30),
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
                              Text('Patient ID: ${patient['id']}'),
                            ],
                          ),
                        )
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
