import 'package:flutter/material.dart';

class Amessage extends StatefulWidget {
  const Amessage({super.key});

  @override
  State<Amessage> createState() => _AmessageState();
}

class _AmessageState extends State<Amessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 27,
                  ),
                ),
                const Text(
                  'Notification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const Icon(
                  Icons.more_vert_outlined,
                  size: 30,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(90, 28, 165, 172),
                      borderRadius: BorderRadius.circular(13)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Aakash Karki',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Admin someone has booked '),
                        Text(
                          '4.44 PM',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
