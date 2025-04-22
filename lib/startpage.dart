import 'package:flutter/material.dart';
import 'package:merodoctor/start1page.dart';

class Startpage extends StatefulWidget {
  const Startpage({super.key});

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF1CA4AC),
        body: Column(
          children: [
            const Spacer(),
            Center(
              child: Image.asset('assets/image/startpage.png'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: InkWell(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: const CircularProgressIndicator(
                            color: Color(0xFF1CA4AC),
                          ),
                        );
                      });
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.pushReplacement(
                      context, //pushreplacement wont let you show the progress indicator when you get back to page
                      MaterialPageRoute(builder: (context) => Start1page()));
                  // Navigator.pop(context);
                },
                child: Container(
                  width: 123,
                  height: 33,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text(
                      'Get Started',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
