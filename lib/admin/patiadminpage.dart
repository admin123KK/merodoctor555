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
              border: OutlineInputBorder()),
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
              onPressed: () {
                setState(() {
                  patients[index]['active'] = true;
                });
                Navigator.pop(context);
              },
              child: const Text('Verify'))
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
                const Text(
                  'Manage Patient',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text("Name",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 3,
                    child: Text("Age",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 2,
                    child: Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    flex: 2,
                    child: Text("Status",
                        style: TextStyle(fontWeight: FontWeight.bold))),
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
                            flex: 2,
                            child: Text(patient['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600))),
                        Expanded(flex: 1, child: Text(patient['age'])),
                        Expanded(
                            child: Text(
                          patient['email'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                          flex: 1,
                          child: patient['active']
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F4EA),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Active",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.green),
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 9, vertical: 8),
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
    );
  }
}
