import 'package:flutter/material.dart';
import 'package:merodoctor/start2page.dart';

class Start1page extends StatefulWidget {
  const Start1page({super.key});

  @override
  State<Start1page> createState() => _Start1pageState();
}

class _Start1pageState extends State<Start1page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Start2page()));
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),

            Center(
              child: Image.asset(
                'assets/image/startpage1.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Container(
                child: const Text(
                  'Consult only  with a doctor you trust',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 180),
              child: Row(
                children: [
                  Container(
                    height: 7,
                    width: 30,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1CA4AC),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  const SizedBox(
                    width: 1.5,
                  ),
                  Container(
                    height: 7,
                    width: 30,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(115, 28, 165, 172),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  const SizedBox(
                    width: 1.5,
                  ),
                  Container(
                    height: 7,
                    width: 30,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(115, 28, 165, 172),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  const SizedBox(
                    height: 30,
                    width: 240,
                  ),
                  InkWell(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1CA4AC),
                              ),
                            );
                          });
                      await Future.delayed(Duration(seconds: 1));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Start2page()));
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: const Color(0xFF1CA4AC),
                            borderRadius: BorderRadius.circular(100)),
                        child: const Icon(
                          Icons.arrow_right_alt_sharp,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),

            // Spacer(),
          ],
        ),
      ),
    );
  }
}
