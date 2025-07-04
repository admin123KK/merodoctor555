import 'package:flutter/material.dart';

class Totalblogpage extends StatefulWidget {
  const Totalblogpage({super.key});

  @override
  State<Totalblogpage> createState() => _TotalblogpageState();
}

class _TotalblogpageState extends State<Totalblogpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios)),
                const Text(
                  'Total Blog',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
