import 'package:flutter/material.dart';

class DAdminPage extends StatefulWidget {
  const DAdminPage({super.key});

  @override
  State<DAdminPage> createState() => _DAdminPageState();
}

class _DAdminPageState extends State<DAdminPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new_outlined),
              Text('Doctor'),
            ],
          )
        ],
      ),
    );
  }
}
