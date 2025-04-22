import 'package:flutter/material.dart';
import 'package:merodoctor/loginpage.dart';

class Start3page extends StatefulWidget {
  const Start3page({super.key});

  @override
  State<Start3page> createState() => _Start3pageState();
}

class _Start3pageState extends State<Start3page> {
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Loginpage()));
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
                'assets/image/startpage3.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Container(
                child: const Text(
                  'Get Connected with our online \nconsulation',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
                    width: 1.5,
                  ),
                  Container(
                    height: 7,
                    width: 30,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1CA4AC),
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
                              builder: (context) => const Loginpage()));
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
                  )
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
