import 'package:flutter/material.dart';

class Historyorsavedpage extends StatefulWidget {
  const Historyorsavedpage({super.key});

  @override
  State<Historyorsavedpage> createState() => _HistoryorsavedpageState();
}

class _HistoryorsavedpageState extends State<Historyorsavedpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 30,
                  ),
                ),
                const Text(
                  'Historyy ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const Icon(
                  Icons.more_vert,
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
