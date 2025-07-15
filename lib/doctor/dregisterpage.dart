import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/admin/specializedpage.dart';
import 'package:merodoctor/api.dart';

import 'dloginpage.dart';

class Dregisterpage extends StatefulWidget {
  const Dregisterpage({super.key});

  @override
  State<Dregisterpage> createState() => _DregisterpageState();
}

class _DregisterpageState extends State<Dregisterpage> {
  // ────────────────────────── text controllers
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _degree = TextEditingController();
  final _experience = TextEditingController();
  final _registrationId = TextEditingController();
  final _clinicAddress = TextEditingController();
  final _password = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // ────────────────────────── specialization data
  List<Specialization> _specializations = [];
  Specialization? _selectedSpec;

  // ────────────────────────── LIFECYCLE
  @override
  void initState() {
    super.initState();
    _fetchSpecializations(); // load dropdown data first
  }

  Future<void> _fetchSpecializations() async {
    try {
      final res = await http.get(Uri.parse(ApiConfig.doctorRegisterUrl));
      if (res.statusCode == 200) {
        final data = (jsonDecode(res.body)['data'] as List)
            .map((e) => Specialization.fromJson(e))
            .toList();
        setState(() => _specializations = data);
      } else {
        debugPrint('Failed to load specializations: ${res.body}');
      }
    } catch (e) {
      debugPrint('Exception while loading specializations: $e');
    }
  }

  // ────────────────────────── REGISTER
  Future<void> _registerDoctor() async {
    // validation
    if ([
          _name,
          _email,
          _phone,
          _degree,
          _experience,
          _registrationId,
          _clinicAddress,
          _password
        ].any((c) => c.text.trim().isEmpty) ||
        _selectedSpec == null) {
      _showError('⚠️ Please fill all fields (including specialization)');
      return;
    }

    final experience = int.tryParse(_experience.text);
    if (experience == null) {
      _showError('⚠️ Experience must be a valid number');
      return;
    }

    setState(() => _isLoading = true);

    const double fixedLat = 27.686386;
    const double fixedLon = 83.432426;

    final body = {
      "fullName": _name.text.trim(),
      "email": _email.text.trim(),
      "phoneNumber": _phone.text.trim(),
      "degree": _degree.text.trim(),
      "experience": experience,
      "registrationId": _registrationId.text.trim(),
      "clinicAddress": _clinicAddress.text.trim(),
      "specializationId": _selectedSpec!.id,
      "latitude": fixedLat,
      "longitude": fixedLon,
      "password": _password.text
    };

    try {
      final res = await http.post(
        Uri.parse(ApiConfig.doctorRegisterUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      setState(() => _isLoading = false);

      if (res.statusCode == 200 || res.statusCode == 201) {
        _showDialog('Success', 'Registered successfully', isError: false);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Dloginpage()));
        });
      } else {
        final j = jsonDecode(res.body);
        _showError('❌ ${j['title'] ?? j['message'] ?? res.body}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('❌ Exception: $e');
    }
  }

  // ────────────────────────── UI HELPERS
  void _showError(String msg) =>
      _showDialog('Something went wrong', msg, isError: true);

  void _showDialog(String title, String msg, {required bool isError}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? Colors.red : Colors.green, size: 30),
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFF1CA4AC)))),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var c in [
      _name,
      _email,
      _phone,
      _degree,
      _experience,
      _registrationId,
      _clinicAddress,
      _password
    ]) c.dispose();
    super.dispose();
  }

  // ────────────────────────── WIDGET TREE
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF1CA4AC),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                  child:
                      Image.asset('assets/image/startpage.png', height: 170)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(55),
                    topRight: Radius.circular(55),
                  ),
                ),
                child: Column(
                  children: [
                    const Text('Register Now Dr.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1CA4AC),
                            fontSize: 28)),
                    const Text('Create new account to Register',
                        style:
                            TextStyle(color: Color(0xFF1CA4AC), fontSize: 12)),
                    _buildField(_name, 'Full Name', Icons.person),
                    _buildField(_email, 'Email', Icons.email),
                    _buildField(_phone, 'Phone Number', Icons.phone),
                    _buildField(_degree, 'Degree', Icons.school),
                    _buildField(
                        _experience, 'Experience (years)', Icons.access_time),
                    _buildField(
                        _registrationId, 'Registration ID', Icons.badge),
                    _buildField(
                        _clinicAddress, 'Clinic Address', Icons.location_on),
                    _buildDropdown(),
                    _buildField(_password, 'Password', Icons.lock,
                        isPassword: true),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator(
                            color: Color(0xFF1CA4AC))
                        : ElevatedButton(
                            onPressed: _registerDoctor,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1CA4AC),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22)),
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
                        const Text('Already have an account?'),
                        InkWell(
                          onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Dloginpage())),
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

  // ────────────────────────── REUSABLE FIELDS
  Widget _buildField(TextEditingController c, String label, IconData icon,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: TextField(
        controller: c,
        obscureText: isPassword ? !_isPasswordVisible : false,
        cursorColor: const Color(0xFF1CA4AC),
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color(0xFF1CA4AC),
                  ),
                  onPressed: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildDropdown() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: DropdownButtonFormField<Specialization>(
          value: _selectedSpec,
          items: _specializations
              .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s.name),
                  ))
              .toList(),
          onChanged: (s) => setState(() => _selectedSpec = s),
          decoration: const InputDecoration(
            labelText: 'Specialization',
            icon: Icon(Icons.star),
          ),
        ),
      );
}
