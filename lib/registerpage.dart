import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'loginpage.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _dob = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _address = TextEditingController();

  int selectedGender = 0; // 0: Male, 1: Female, 2: Other
  bool isLoading = false;

  double latitude = 0; // Provide real values later
  double longitude = 0;

  Future<void> registerUser() async {
    if (_fullName.text.isEmpty ||
        _email.text.isEmpty ||
        _phone.text.isEmpty ||
        _dob.text.isEmpty ||
        _address.text.isEmpty ||
        _password.text.isEmpty ||
        _confirmPassword.text.isEmpty) {
      showMessage("⚠️ Please fill all fields");
      return;
    }

    if (_password.text != _confirmPassword.text) {
      showMessage("❌ Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
          "https://c2e1-2400-1a00-bb20-fd39-7053-b143-a1b-375.ngrok-free.app/api/AuthPatientRegistration/register-patient");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fullName": _fullName.text,
          "email": _email.text,
          "phoneNumber": _phone.text,
          "dateOfBirth": DateFormat("yyyy-MM-dd'T'HH:mm:ss")
              .format(DateTime.parse(_dob.text)),
          "gender": selectedGender,
          "address": _address.text,
          "latitude": latitude,
          "longitude": longitude,
          "password": _password.text,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        showMessage("✅ Registration successful");
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Loginpage()));
        });
      } else {
        final body = jsonDecode(response.body);
        showMessage("❌ ${body['title'] ?? 'Unknown Error'}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showMessage("❌ Exception: $e");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _dob.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _address.dispose();
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
                    topRight: Radius.circular(55)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text('Register Now',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1CA4AC),
                          fontSize: 30)),
                  const Text('Create new account to register',
                      style: TextStyle(color: Color(0xFF1CA4AC), fontSize: 12)),
                  buildTextField(_fullName, 'Full Name', Icons.person),
                  buildTextField(_email, 'Email', Icons.email),
                  buildTextField(_phone, 'Phone Number', Icons.phone),
                  buildTextField(_address, 'Address', Icons.location_city),
                  buildDatePicker(),
                  buildGenderDropdown(),
                  buildTextField(_password, 'Password', Icons.lock,
                      isPassword: true),
                  buildTextField(
                      _confirmPassword, 'Confirm Password', Icons.lock,
                      isPassword: true),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF1CA4AC))
                      : ElevatedButton(
                          onPressed: registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1CA4AC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text('Register',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have account?'),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Loginpage()));
                        },
                        child: const Text(' Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1CA4AC))),
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

  Widget buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: TextField(
        controller: _dob,
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now());

          if (pickedDate != null) {
            _dob.text = pickedDate.toIso8601String(); // ISO format
          }
        },
        decoration: const InputDecoration(
          labelText: "Date of Birth",
          hintText: "Select your birth date",
          icon: Icon(Icons.calendar_today),
          labelStyle: TextStyle(color: Color(0xFF1CA4AC)),
        ),
      ),
    );
  }

  Widget buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.transgender, color: Colors.grey),
          const SizedBox(width: 15),
          const Text('Gender:', style: TextStyle(color: Color(0xFF1CA4AC))),
          const SizedBox(width: 15),
          DropdownButton<int>(
            value: selectedGender,
            items: const [
              DropdownMenuItem(value: 0, child: Text("Male")),
              DropdownMenuItem(value: 1, child: Text("Female")),
              DropdownMenuItem(value: 2, child: Text("Other")),
            ],
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
              });
            },
          ),
        ],
      ),
    );
  }
}
