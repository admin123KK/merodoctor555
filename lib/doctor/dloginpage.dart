import 'package:flutter/material.dart';
import 'package:merodoctor/doctor/dregisterpage.dart';
import 'package:merodoctor/forgotpassword.dart';
import 'package:merodoctor/homepage.dart';
import 'package:merodoctor/loginpage.dart';

class Dloginpage extends StatefulWidget {
  const Dloginpage({super.key});

  @override
  State<Dloginpage> createState() => _DloginpageState();
}

class _DloginpageState extends State<Dloginpage> {
  late final _password = TextEditingController();
  late final _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1CA4AC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 170,
                    width: 170,
                    child: Image.asset('assets/image/startpage.png'),
                  ),
                ],
              ),
            ),
            Container(
              height: 630,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(55),
                      topRight: Radius.circular(55))),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Welcome Back Dr.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Color(0xFF1CA4AC)),
                  ),
                  const Text(
                    'Login to Your Account',
                    style: TextStyle(color: Color(0xFF1CA4AC)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 27, vertical: 50),
                    child: TextField(
                      controller: _email,
                      cursorColor: Colors.blue,
                      decoration: const InputDecoration(
                        hintText: 'enter your id number',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Id Number',
                        labelStyle: TextStyle(color: Color(0xFF1CA4AC)),
                        icon: Icon(
                          Icons.email_outlined,
                          // color: Color(0xFF1CA4AC),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        cursorColor: const Color(0xFF1CA4AC),
                        controller: _password,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.lock_outline,
                          ),
                          hintText: 'Enter you password',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Color(0xFF1CA4AC),
                          ),
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: InkWell(
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
                                    builder: (context) =>
                                        const Forgotpassword()));
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1CA4AC)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 55,
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
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Homepage()));
                    },
                    child: Container(
                      height: 30,
                      width: 123,
                      decoration: BoxDecoration(
                          color: const Color(0xFF1CA4AC),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Register as Doctor?"),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dregisterpage()));
                        },
                        child: const Text(
                          ' Register',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1CA4AC)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('or'),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Login as User?'),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Loginpage()));
                        },
                        child: const Text(
                          ' Start',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1CA4AC)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
