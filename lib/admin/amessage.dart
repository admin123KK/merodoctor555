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
                  'Message',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Icon(
                  Icons.more_vert_outlined,
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
