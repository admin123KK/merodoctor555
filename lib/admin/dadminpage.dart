import 'package:flutter/material.dart';

class DAdminPage extends StatefulWidget {
  const DAdminPage({super.key});

  @override
  State<DAdminPage> createState() => _DAdminPageState();
}

class _DAdminPageState extends State<DAdminPage> {
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
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.black,
                      size: 27,
                    )),
                const Text(
                  'Doctor Manage',
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
