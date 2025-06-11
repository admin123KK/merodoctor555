import 'package:flutter/material.dart';

class Dmessage extends StatefulWidget {
  const Dmessage({super.key});

  @override
  State<Dmessage> createState() => _DmessageState();
}

class _DmessageState extends State<Dmessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 55,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                const Text(
                  'Notifications',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                  size: 30,
                )
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
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(90, 28, 165, 172),
                      borderRadius: BorderRadius.circular(13)),
                  child: const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Doctor Sky',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Doctor your appointment  for 4.40AM'),
                        Text(
                          '5.55 AM',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
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
