import 'package:flutter/material.dart';

class Totalphneumpage extends StatefulWidget {
  const Totalphneumpage({super.key});

  @override
  State<Totalphneumpage> createState() => _TotalphneumpageState();
}

class _TotalphneumpageState extends State<Totalphneumpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 70,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                    )),
                const Text(
                  'Total Phneumonia',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Icon(Icons.more_vert),
              ],
            ),
          )
        ],
      ),
    );
  }
}
