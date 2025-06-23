import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merodoctor/doctordetailspage.dart';
import 'package:merodoctor/message.dart';
import 'package:merodoctor/profilepage.dart';
import 'package:merodoctor/reportcheck.dart';

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
      greeting = "Good morning";
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
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategory('Doctor', Icons.person_search_outlined),
                      _buildCategory('Pharmacy', Icons.medication_outlined),
                      _buildCategory('Emergency', Icons.warning_amber_outlined),
                      _buildCategory('Hospital', Icons.local_hospital_outlined),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildPromoCard(),
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
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildDoctorCard(
                          'assets/image/startpage1.png',
                          'Dr.Sky Karki',
                          'Cardiologist',
                          4.8,
                        ),
                        _buildDoctorCard(
                          'assets/image/startpage3.png',
                          'Dr. Abiskar Gyawali',
                          'Orthopedist',
                          4.6,
                        ),
                        _buildDoctorCard(
                          'assets/image/startpage3.png',
                          'Ritesh Ac',
                          'Psychologist',
                          4.9,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Doctor Blogs',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  _buildBlogCard(
                    imagePath: 'assets/image/startpage1.png',
                    title: 'Heart Care Tips',
                    description: 'Simple tips to keep your heart healthy...',
                    doctorName: 'Dr. Sky Karki',
                    category: 'Cardiology',
                    time: DateFormat('MMM d, h:mm a').format(DateTime.now()),
                  ),
                  _buildBlogCard(
                    imagePath: 'assets/image/startpage3.png',
                    title: 'Joint Pain Relief',
                    description:
                        'How to relieve knee and joint pain naturally.',
                    doctorName: 'Dr. Abiskar Gyawali',
                    category: 'Orthopedics',
                    time: DateFormat('MMM d, h:mm a').format(DateTime.now()),
                  ),
                ],
              ),
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.black,
                  size: 33,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildCategory(String title, IconData icon) {
    return Column(
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, size: 30),
        ),
        Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        )
      ],
    );
  }

  Widget _buildPromoCard() {
    return Container(
      height: 180,
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Early Protection for \n your family',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  height: 25,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1CA4AC),
                    borderRadius: BorderRadius.circular(20),
                  ),
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
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(70),
              ),
              child:
                  Image.asset('assets/image/startpage3.png', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(
      String imagePath, String name, String type, double rating) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Doctordetailspage()));
          },
          child: Container(
            width: 160,
            height: 220,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(93, 28, 165, 172),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 60,
                  backgroundImage: AssetImage(imagePath),
                ),
                const SizedBox(height: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(type, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlogCard({
    required String imagePath,
    required String title,
    required String description,
    required String doctorName,
    required String time,
    required String category,
  }) {
    return Card(
      color: const Color.fromARGB(93, 28, 165, 172),
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath,
                  height: 80, width: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Text('$doctorName • $category • $time',
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.home_outlined, size: 30, color: Color(0xFF1CA4AC)),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Pmessage()));
                },
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Reportcheck()));
                    },
                    child: const Icon(Icons.qr_code_outlined, size: 30))),
            const InkWell(child: Icon(Icons.calendar_month_outlined, size: 30)),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profilepage()));
                },
                child: const Icon(Icons.person_outline_rounded, size: 30)),
          ],
        ),
      ),
    );
  }
}
