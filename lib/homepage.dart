import 'package:flutter/material.dart';
import 'package:merodoctor/doctor/doctordetailspage.dart';
import 'package:merodoctor/profilepage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String greeting = "";

  @override
  void initState() {
    updateGreeting();
    super.initState();
  }

  void updateGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    if (hour < 12) {
      greeting = "Good morning"; // corrected typo
    } else if (hour < 17) {
      greeting = "Good afternoon";
    } else {
      greeting = "Good evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 65),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find your desire \nhealth Solution',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$greeting, Sky',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(22),
                      ),
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.person_search_outlined,
                              size: 30,
                            ),
                          ),
                          const Text(
                            'Doctor',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Icon(
                              Icons.medication_outlined,
                              size: 30,
                            ),
                          ),
                          const Text(
                            'Pharmacy',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Icon(
                              Icons.warning_amber_outlined,
                              size: 30,
                            ),
                          ),
                          const Text(
                            'Emergency',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Icon(
                              Icons.local_hospital_outlined,
                              size: 30,
                            ),
                          ),
                          const Text(
                            'Hospital',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 230,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(90, 28, 165, 172),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                'Early Protection for \n your family',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Container(
                                height: 25,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1CA4AC),
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Center(
                                  child: Text(
                                    'Learn more',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 0),
                            child: Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(70)),
                              child: Image.asset(
                                'assets/image/startpage3.png',
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'See all',
                          style: TextStyle(color: Color(0xFF1CA4AC)),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Top Doctor',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildDoctorCard(
                          ('assets/image/startpage1.png'),
                          'Dr.SKy Karki',
                          'Cardiologist',
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Doctordetailspage()));
                          },
                        ),
                        _buildDoctorCard(
                          ('assets/image/startpage3.png'),
                          'Dr.Abiskar Gyawali',
                          'Orthopedist',
                          () {},
                        ),
                        _buildDoctorCard(
                          ('assets/image/startpage3.png'),
                          'Ritesh Ac',
                          'Psychologist',
                          () {},
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Positioned(
                top: 0,
                right: 0,
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.black,
                  size: 33,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 3,
                offset: Offset(0, 2),
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.home_outlined,
                size: 30,
                color: Color(0xFF1CA4AC),
              ),
              const Icon(
                Icons.mail_outline,
                size: 30,
              ),
              const Icon(
                Icons.calendar_month_outlined,
                size: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profilepage()));
                },
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDoctorCard(
    String imagePath, String name, String type, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.only(right: 15),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Container(
        width: 160,
        height: 230,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color.fromARGB(93, 28, 165, 172),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 58,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              type,
              style: const TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: onTap,
              child: Container(
                height: 20,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: InkWell(
                    child: Text(
                      'Visit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
