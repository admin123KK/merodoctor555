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
          )
        ],
      ),
    );
  }
}
