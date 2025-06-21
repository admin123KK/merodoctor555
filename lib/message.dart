import 'package:flutter/material.dart';

class Pmessage extends StatefulWidget {
  const Pmessage({super.key});

  @override
  State<Pmessage> createState() => _PmessageState();
}

class _PmessageState extends State<Pmessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 27,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Expanded(
                  child: const Text(
                    'Notification',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
              children: List.generate(10, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(90, 28, 165, 172),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Aakash Karki',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Booked the appointment for 8.30'),
                      Text(
                        '11.11 AM',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 11),
                      )
                    ],
                  ),
                ),
              ),
            );
          }))
        ],
      ),
    );
  }
}
