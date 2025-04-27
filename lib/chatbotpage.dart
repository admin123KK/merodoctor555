import 'package:flutter/material.dart';
import 'package:merodoctor/profilepage.dart';

class Chatbotpage extends StatefulWidget {
  const Chatbotpage({super.key});

  @override
  State<Chatbotpage> createState() => _ChatbotpageState();
}

class _ChatbotpageState extends State<Chatbotpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profilepage()));
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 30,
                  ),
                ),
                const Text(
                  'MeroDoctor Sathi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Icon(Icons.more_vert_outlined),
              ],
            ),
          )
        ],
      ),
    );
  }
}
