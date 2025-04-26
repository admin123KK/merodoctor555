import 'package:flutter/material.dart';
import 'package:merodoctor/homepage.dart';
import 'package:merodoctor/loginpage.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  late final _name = TextEditingController();
  late final _password = TextEditingController();
  late final _address = TextEditingController();
  late final _contract = TextEditingController();
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
                  topRight: Radius.circular(55),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Register Now',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1CA4AC),
                        fontSize: 30),
                  ),
                  const Text(
                    'Create new account to Register',
                    style: TextStyle(color: Color(0xFF1CA4AC), fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: _name,
                      cursorColor: const Color(0xFF1CA4AC),
                      decoration: const InputDecoration(
                          hintText: 'enter your  full name',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: Color(0xFF1CA4AC)),
                          icon: Icon(Icons.person_outline)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _contract,
                      cursorColor: const Color(0xFF1CA4AC),
                      decoration: const InputDecoration(
                          hintText: 'enter your contract no',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: 'Contract No',
                          labelStyle: TextStyle(color: Color(0xFF1CA4AC)),
                          icon: Icon(Icons.phone_outlined)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: _address,
                      cursorColor: const Color(0xFF1CA4AC),
                      decoration: const InputDecoration(
                          hintText: 'enter your address',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: 'Address',
                          labelStyle: TextStyle(color: Color(0xFF1CA4AC)),
                          icon: Icon(Icons.location_city)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: _password,
                      cursorColor: const Color(0xFF1CA4AC),
                      decoration: const InputDecoration(
                          hintText: 'enter your new password',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Color(0xFF1CA4AC)),
                          icon: Icon(Icons.lock_outline)),
                    ),
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      cursorColor: const Color(0xFF1CA4AC),
                      decoration: const InputDecoration(
                          hintText: 'confirm password',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: Color(0xFF1CA4AC)),
                          icon: Icon(Icons.lock_outline)),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
                      await Future.delayed(Duration(seconds: 3));
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Loginpage()));
                    },
                    child: Container(
                      height: 30,
                      width: 123,
                      decoration: BoxDecoration(
                        color: Color(0xFF1CA4AC),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Center(
                          child: Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have account?'),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Homepage()));
                        },
                        child: const Text(
                          ' Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1CA4AC)),
                        ),
                      ),
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
