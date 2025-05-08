import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dloginpage.dart'; // Assuming this is the login page after registration

class Dregisterpage extends StatefulWidget {
  const Dregisterpage({super.key});

  @override
  State<Dregisterpage> createState() => _DregisterpageState();
}

class _DregisterpageState extends State<Dregisterpage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _degree = TextEditingController();
  final _experience = TextEditingController();
  final _registrationId = TextEditingController();
  final _clinicAddress = TextEditingController();
  final _specializationId = TextEditingController();
  final _password = TextEditingController();

  bool isLoading = false;

  Future<void> registerDoctor() async {
    if (_name.text.isEmpty ||
        _email.text.isEmpty ||
        _phone.text.isEmpty ||
        _degree.text.isEmpty ||
        _experience.text.isEmpty ||
        _registrationId.text.isEmpty ||
        _clinicAddress.text.isEmpty ||
        _specializationId.text.isEmpty ||
        _password.text.isEmpty) {
      showMessage("⚠️ Please fill all fields");
      return;
    }

    int? experience = int.tryParse(_experience.text);
    int? specializationId = int.tryParse(_specializationId.text);

    if (experience == null || specializationId == null) {
      showMessage("⚠️ Experience and Specialization ID must be valid numbers");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
        'https://0d71-2400-1a00-bb20-5718-d481-a287-47e2-576.ngrok-free.app/api/AuthDoctorRegistration/register-doctor',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fullName": _name.text,
          "email": _email.text,
          "phoneNumber": _phone.text,
          "degree": _degree.text,
          "experience": experience,
          "registrationId": _registrationId.text,
          "clinicAddress": _clinicAddress.text,
          "specializationId": specializationId,
          "password": _password.text,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  content: Text(
                    'Login Success',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    Text(
                      'Register Successfully',
                      style: TextStyle(color: Colors.green),
                    )
                  ],
                ));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Dloginpage()));
        });
      } else {
        try {
          final body = jsonDecode(response.body);
          final errorMessage = body['title'] ??
              body['message'] ??
              body['error'] ??
              response.body;
          showMessage("❌ $errorMessage");
        } catch (_) {
          showMessage("❌ Server error: ${response.statusCode}");
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showMessage("❌ Exception: $e");
    }
  }

  void showMessage(String msg) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 30,
        ),
        title: const Text('Something went wrong'),
        content: Text(
          msg,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Text('Cancel'))),
                InkWell(
                  child: Container(
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1CA4AC),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _degree.dispose();
    _experience.dispose();
    _registrationId.dispose();
    _clinicAddress.dispose();
    _specializationId.dispose();
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
            const SizedBox(height: 100),
            Center(
              child: Image.asset('assets/image/startpage.png', height: 170),
            ),
            Container(
              height: 850,
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
                  const SizedBox(height: 10),
                  const Text(
                    'Register Now Dr.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1CA4AC),
                      fontSize: 30,
                    ),
                  ),
                  const Text(
                    'Create new account to Register',
                    style: TextStyle(color: Color(0xFF1CA4AC), fontSize: 12),
                  ),
                  buildTextField(_name, 'Full Name', Icons.person),
                  buildTextField(_email, 'Email', Icons.email),
                  buildTextField(_phone, 'Phone Number', Icons.phone),
                  buildTextField(_degree, 'Degree', Icons.school),
                  buildTextField(
                      _experience, 'Experience (years)', Icons.access_time),
                  buildTextField(
                      _registrationId, 'Registration ID', Icons.badge),
                  buildTextField(
                      _clinicAddress, 'Clinic Address', Icons.location_on),
                  buildTextField(
                      _specializationId, 'Specialization ID', Icons.star),
                  buildTextField(_password, 'Password', Icons.lock,
                      isPassword: true),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF1CA4AC))
                      : ElevatedButton(
                          onPressed: registerDoctor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1CA4AC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const Dloginpage()),
                          );
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

  Widget buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        cursorColor: const Color(0xFF1CA4AC),
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          labelStyle: const TextStyle(color: Color(0xFF1CA4AC)),
          icon: Icon(icon),
        ),
      ),
    );
  }
}
