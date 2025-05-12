import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/admin/aloginpage.dart';
import 'package:merodoctor/doctor/dloginpage.dart';
import 'package:merodoctor/forgotpassword.dart';
import 'package:merodoctor/homepage.dart';
import 'package:merodoctor/registerpage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> loginUser(String email, String password) async {
    const String apiUrl =
        "https://5461-2400-1a00-bb20-aa34-b8b7-6651-6dc9-cd27.ngrok-free.app/api/Auth/login";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      // Close the loading dialog
      Navigator.pop(context);

      if (response.statusCode == 200 && data['success']) {
        final token = data['data'];
        print("Login Successful! JWT Token: $token");
        showSuccessMessage('Login Successful');
        await Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => Homepage()));
        });
      } else {
        showErrorMessage(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      // Close the loading dialog
      Navigator.pop(context);
      showErrorMessage('Something went wrong on server');
    }
  }

  void showSuccessMessage(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 30,
        ),
        title: const Text('Success'),
        content: Text(
          msg,
          style: const TextStyle(color: Colors.green),
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF1CA4AC)),
            ),
          )
        ],
      ),
    );
  }

  void showErrorMessage(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 30,
        ),
        title: const Text('Login Error'),
        content: Text(
          msg,
          style: const TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF1CA4AC)),
            ),
          ),
        ],
      ),
    );
  }

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
                  SizedBox(
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
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome Back',
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
                        hintText: 'Enter your email addresss',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Color(0xFF1CA4AC)),
                        icon: Icon(Icons.email_outlined),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      cursorColor: const Color(0xFF1CA4AC),
                      controller: _password,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock_outline),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Color(0xFF1CA4AC)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: InkWell(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) => const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFF1CA4AC))),
                            );
                            await Future.delayed(const Duration(seconds: 1));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Forgotpassword()),
                            );
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
                  const SizedBox(height: 55),
                  InkWell(
                    onTap: () async {
                      final email = _email.text.trim();
                      final password = _password.text.trim();

                      // Show loading dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1CA4AC),
                          ),
                        ),
                      );

                      // Simulate a 2-second delay for processing login
                      await Future.delayed(const Duration(seconds: 2));

                      // Perform the login request
                      await loginUser(email, password);
                    },
                    child: Container(
                      height: 30,
                      width: 123,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1CA4AC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Didn't have account?"),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Registerpage()),
                          );
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
                  const SizedBox(height: 10),
                  const Text('or'),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 90,
                          width: 80,
                          decoration: BoxDecoration(
                              color: const Color(0xFF1CA4AC),
                              border:
                                  Border.all(color: const Color(0xFF1CA4AC)),
                              borderRadius: BorderRadius.circular(15)),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outline, color: Colors.white),
                              Text(
                                'User \nLogin',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) => const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFF1CA4AC))),
                            );
                            await Future.delayed(const Duration(seconds: 3));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dloginpage()),
                            );
                          },
                          child: Container(
                            height: 90,
                            width: 80,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFF1CA4AC)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_4_outlined),
                                Text(
                                  'Doctor \nLogin',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) => const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFF1CA4AC))),
                            );
                            await Future.delayed(const Duration(seconds: 2));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Aloginpage()),
                            );
                          },
                          child: Container(
                            height: 90,
                            width: 80,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFF1CA4AC)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.admin_panel_settings_outlined),
                                Text(
                                  'Merchant \nLogin',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
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
