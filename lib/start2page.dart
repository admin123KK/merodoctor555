import 'package:flutter/material.dart';
import 'package:merodoctor/start3page.dart';

class Start2page extends StatefulWidget {
  const Start2page({super.key});

  @override
  State<Start2page> createState() => _Start2pageState();
}

class _Start2pageState extends State<Start2page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Start3page()));
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Image.asset('assets/image/startpage2.png'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Find a lot  of specialist doctor \nin one place',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 110),
              child: Row(
                children: [
                  Container(
                    height: 7,
                    width: 33,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(115, 28, 165, 172),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  const SizedBox(
                    width: 1.5,
                  ),
                  Container(
                    height: 7,
                    width: 33,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1CA4AC),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  const SizedBox(
                    width: 1.5,
                  ),
                  Container(
                    height: 7,
                    width: 33,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(115, 28, 165, 172),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  const SizedBox(
                    height: 20,
                    width: 240,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Start3page()));
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: const Color(0xFF1CA4AC),
                          borderRadius: BorderRadius.circular(70)),
                      child: const Icon(
                        Icons.arrow_right_alt_sharp,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
