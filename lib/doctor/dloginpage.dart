import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/admin/aloginpage.dart';
import 'package:merodoctor/doctor/dhomepage.dart';
import 'package:merodoctor/doctor/dregisterpage.dart';
import 'package:merodoctor/forgotpassword.dart';
import 'package:merodoctor/loginpage.dart';

class Dloginpage extends StatefulWidget {
  const Dloginpage({super.key});

  @override
  State<Dloginpage> createState() => _DloginpageState();
}

class _DloginpageState extends State<Dloginpage> {
  final _password = TextEditingController();
  final _email = TextEditingController();
  bool isLoading = false;

  Future<void> loginDoctor() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      showErrorMessage("Please fill in both fields", isError: true);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
          'https://c2e1-2400-1a00-bb20-fd39-7053-b143-a1b-375.ngrok-free.app/api/Auth/login'); // Replace this with actual URL
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": _email.text,
          "password": _password.text,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        showSuccessMessage("Login successful", isError: false);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Dhomepage()));
        });
      } else {
        final body = jsonDecode(response.body);
        showErrorMessage(body["message"] ?? "Login failed", isError: true);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorMessage("Invalid Crediental", isError: true);
    }
  }

  void showErrorMessage(String msg, {required bool isError}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(
          isError ? Icons.error_outline : Icons.check_circle_outline,
          color: isError ? Colors.red : Colors.green,
          size: 30,
        ),
        title: Text(isError ? 'Login Error' : 'Success'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              msg,
              style: const TextStyle(color: Colors.red),
            ),
          ],
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

  void showSuccessMessage(String msg, {required bool isError}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 30,
        ),
        title: Text(isError ? 'Login Error' : 'Success'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              msg,
              style: const TextStyle(color: Colors.green),
            ),
          ],
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
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1CA4AC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Center(
              child: Image.asset('assets/image/startpage.png', height: 170),
            ),
            Container(
              height: 700,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(55)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
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
                    padding: const EdgeInsets.all(27),
                    child: TextField(
                      controller: _email,
                      cursorColor: Colors.blue,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        labelText: 'Email',
                        icon: Icon(Icons.email_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: _password,
                      cursorColor: const Color(0xFF1CA4AC),
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock_outline),
                        hintText: 'Enter your password',
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1CA4AC),
                              ),
                            ),
                          );
                          await Future.delayed(const Duration(seconds: 1));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Forgotpassword()));
                        },
                        child: const Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Color(0xFF1CA4AC)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF1CA4AC))
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1CA4AC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                          ),
                          onPressed: loginDoctor,
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Register as Doctor?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Dregisterpage()));
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Color(0xFF1CA4AC)),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  const Text("or "),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _loginRoleBox(
                        icon: Icons.person_outline,
                        label: 'User Login',
                        onTap: () async {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Loginpage()));
                        },
                      ),
                      _loginRoleBox(
                        icon: Icons.person_4_outlined,
                        label: 'Doctor Login',
                        color: const Color(0xFF1CA4AC),
                        textColor: Colors.white,
                      ),
                      _loginRoleBox(
                        icon: Icons.admin_panel_settings_outlined,
                        label: 'Admin Login',
                        onTap: () async {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Aloginpage()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginRoleBox({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Color color = Colors.white,
    Color textColor = Colors.black,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 90,
        width: 80,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: const Color(0xFF1CA4AC)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
