import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedBackPage extends StatefulWidget {
  const FeedBackPage({super.key});

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _loading = false;

  Future<String?> _token() async {
    return (await SharedPreferences.getInstance()).getString('token');
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final description = _descriptionController.text.trim();

    final token = await _token();

    if (token == null) {
      _showMessageDialog("Error", "User not authenticated.");
      return;
    }

    final payload = {
      "email": email,
      "description": description,
    };

    setState(() {
      _loading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.createFeedback),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _showMessageDialog(
              "Success", data['message'] ?? "Feedback submitted successfully.");
          _formKey.currentState!.reset();
          // Clear the actual text fields
          _emailController.clear();
          _descriptionController.clear();
        } else {
          _showMessageDialog(
              "Error", data['message'] ?? "Failed to submit feedback.");
        }
      } else {
        String message =
            "Failed to submit feedback. Status code: ${response.statusCode}";
        if (response.body.isNotEmpty) {
          final errData = jsonDecode(response.body);
          if (errData['message'] != null) message = errData['message'];
        }
        _showMessageDialog("Error", message);
      }
    } catch (e) {
      _showMessageDialog("Error", "Unexpected error: $e");
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _showMessageDialog(String title, String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email is required";
                  }
                  // Simple email validation
                  if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$')
                      .hasMatch(value.trim())) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Description is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitFeedback,
                      child: const Text("Submit Feedback"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
