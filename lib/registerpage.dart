import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart'; // Make sure ApiConfig.registerPatientUrl is defined here

import 'loginpage.dart'; // Make sure LoginPage is defined here

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

  int selectedGender = 0;
  bool isLoading = false;

  // Fixed latitude and longitude values
  final double latitude = 27.686386;
  final double longitude = 83.432426;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // latitude and longitude are initialized above as final, no need to set in initState
  }

  Future<void> registerUser() async {
    // Basic form validation
    if (_fullName.text.isEmpty ||
        _email.text.isEmpty ||
        _phone.text.isEmpty ||
        _dob.text.isEmpty ||
        _address.text.isEmpty ||
        _password.text.isEmpty ||
        _confirmPassword.text.isEmpty) {
      showErrorMessage("⚠️ Please fill all fields");
      return;
    }

    if (_password.text != _confirmPassword.text) {
      showErrorMessage("❌ Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse(
            ApiConfig.registerPatientUrl), // Your registration API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fullName": _fullName.text,
          "email": _email.text,
          "phoneNumber": _phone.text,
          "dateOfBirth": _dob
              .text, // Ensure this format matches backend's expectation (e.g., "YYYY-MM-DD")
          "gender": selectedGender,
          "address": _address.text,
          "latitude": latitude, // Using fixed latitude
          "longitude": longitude, // Using fixed longitude
          "password": _password.text
        }),
      );

      setState(() {
        isLoading = false; // Hide loading indicator
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success response
        final body = jsonDecode(response.body);
        final backendMessage = body['message'] ??
            "Registration successful."; // Get message from backend
        showSuccessMessage("✅ $backendMessage", isError: false);

        // Navigate to login page after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Loginpage()));
        });
      } else {
        // Error response from backend
        final body = jsonDecode(response.body);
        // Try to get 'message' first, then 'title' (common for validation errors), fallback to generic error
        final backendMessage =
            body['message'] ?? body['title'] ?? "Unknown error occurred.";
        showErrorMessage("❌ $backendMessage");
      }
    } catch (e) {
      // Network or other unexpected errors
      setState(() {
        isLoading = false;
      });
      showErrorMessage(
          "❌ An unexpected error occurred. Please check your internet connection.");
      print('Registration error: $e'); // For debugging
    }
  }

  // Custom dialog for showing error messages
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
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1CA4AC),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                      child: Text(
                        'OK',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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

  // Custom dialog for showing success messages
  void showSuccessMessage(String msg, {required bool isError}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle_outline,
            color: Colors.green, size: 30),
        title: Text(
            isError ? 'Login Error' : 'Success'), // Title adjusted for clarity
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              // Use Flexible to prevent text overflow
              child: Text(msg,
                  textAlign: TextAlign
                      .center, // Center align text for better appearance
                  style: const TextStyle(color: Colors.green)),
            ),
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
              height: 850, // Adjust height as needed based on content
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
                  // Text input fields
                  buildTextField(_fullName, 'Full Name', Icons.person),
                  buildTextField(_email, 'Email', Icons.email),
                  buildTextField(_phone, 'Phone Number', Icons.phone),
                  buildTextField(_address, 'Address', Icons.location_city),
                  buildDatePicker(), // Date of birth picker
                  buildGenderDropdown(), // Gender selection
                  buildTextField(_password, 'Password', Icons.lock,
                      isPassword: true),
                  buildTextField(
                      _confirmPassword, 'Confirm Password', Icons.lock,
                      isPassword: true),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator(
                          // Loading indicator
                          color: Color(0xFF1CA4AC))
                      : ElevatedButton(
                          // Register button
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
                  // Link to Login page
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

  // Reusable widget for text input fields
  Widget buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    bool isMainPassword = label == 'Password';
    bool isConfirmPassword = label == 'Confirm Password';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: isPassword
            ? (isMainPassword ? _obscurePassword : _obscureConfirmPassword)
            : false,
        cursorColor: const Color(0xFF1CA4AC),
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          labelStyle: const TextStyle(color: Color(0xFF1CA4AC)),
          icon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    (isMainPassword
                            ? _obscurePassword
                            : _obscureConfirmPassword)
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF1CA4AC),
                  ),
                  onPressed: () {
                    setState(() {
                      if (isMainPassword) {
                        _obscurePassword = !_obscurePassword;
                      } else {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  // Widget for date of birth picker
  Widget buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: TextField(
        controller: _dob,
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2000), // Default initial year
              firstDate: DateTime(1900), // Earliest selectable year
              lastDate: DateTime.now()); // Latest selectable year (today)

          if (pickedDate != null) {
            // Format the date to ISO 8601 string (e.g., "2000-10-25T00:00:00.000Z")
            // Ensure your backend can parse this or format it as "YYYY-MM-DD" if required by your DTO.
            // Example for "YYYY-MM-DD": DateFormat('yyyy-MM-dd').format(pickedDate);
            _dob.text = pickedDate.toIso8601String();
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

  // Widget for gender dropdown selection
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
                selectedGender = value!; // Update selected gender
              });
            },
          ),
        ],
      ),
    );
  }
}
