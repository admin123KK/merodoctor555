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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  'Notification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
