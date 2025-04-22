import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 65),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to top
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find your desire \nhealth Solution',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Good morning, Sky Karki',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Icon(
              Icons.notifications_active_outlined,
              color: Colors.black,
              size: 33,
            ),
          ],
        ),
      ),
    );
  }
}
