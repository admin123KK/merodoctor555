import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart';
import 'dloginpage.dart';

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
  final _password = TextEditingController();

  int? _selectedSpecializationId;

  bool isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> registerDoctor() async {
    if (_name.text.isEmpty ||
        _email.text.isEmpty ||
        _phone.text.isEmpty ||
        _degree.text.isEmpty ||
        _experience.text.isEmpty ||
        _registrationId.text.isEmpty ||
        _clinicAddress.text.isEmpty ||
        _selectedSpecializationId == null ||
        _password.text.isEmpty) {
      showErrorMessage("⚠️ Please fill all fields");
      return;
    }

    int? experience = int.tryParse(_experience.text);

    if (experience == null) {
      showErrorMessage("⚠️ Experience must be a valid number");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(ApiConfig.doctorRegisterUrl);
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
          "specializationId": _selectedSpecializationId,
          "password": _password.text,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        showSuccessMessage('Login Successfully', isError: false);
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
          showErrorMessage("❌ $errorMessage");
        } catch (_) {
          showErrorMessage("❌ Server error: ${response.statusCode}");
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorMessage("❌ Exception: $e");
    }
  }

  void showErrorMessage(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.error_outline, color: Colors.red, size: 30),
        title: const Text('Something went wrong'),
        content: Text(msg),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                InkWell(
                  child: Container(
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1CA4AC),
                      borderRadius: BorderRadius.circular(15),
                    ),
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

  void showSuccessMessage(String msg, {required bool isError}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle_outline,
            color: Colors.green, size: 30),
        title: Text(isError ? 'Login Error' : 'Success'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(msg, style: const TextStyle(color: Colors.green)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF1CA4AC))),
          ),
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
            const SizedBox(height: 30),
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
                        fontSize: 30),
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
                  buildDropdown(),
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
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        cursorColor: const Color(0xFF1CA4AC),
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          labelStyle: const TextStyle(color: Color(0xFF1CA4AC)),
          icon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color(0xFF1CA4AC),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget buildDropdown() {
    List<int> specializationOptions = [0, 1, 3, 4, 5];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: DropdownButtonFormField<int>(
        value: _selectedSpecializationId,
        items: specializationOptions.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text("Specialization ID: $value"),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedSpecializationId = value;
          });
        },
        decoration: const InputDecoration(
          labelText: 'Specialization ID',
          labelStyle: TextStyle(color: Color(0xFF1CA4AC)),
          icon: Icon(Icons.star),
        ),
        dropdownColor: Colors.white,
      ),
    );
  }
}
