import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:merodoctor/api.dart';
import 'package:merodoctor/profilepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reportcheck extends StatefulWidget {
  const Reportcheck({Key? key}) : super(key: key);

  @override
  State<Reportcheck> createState() => _ReportcheckState();
}

class _ReportcheckState extends State<Reportcheck> {
  File? _image;
  bool _uploading = false;

  Future<String?> _token() async =>
      (await SharedPreferences.getInstance()).getString('token');

  Future<void> _pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: false);
    if (result != null && result.files.single.path != null) {
      setState(() => _image = File(result.files.single.path!));
    }
  }

  Future<void> _upload() async {
    if (_image == null) return;
    setState(() => _uploading = true);

    final tok = await _token();
    if (tok == null) {
      _snack('Auth token missing');
      setState(() => _uploading = false);
      return;
    }

    final req =
        http.MultipartRequest('POST', Uri.parse(ApiConfig.detectPneumonia))
          ..headers['Authorization'] = 'Bearer $tok'
          ..files.add(
            await http.MultipartFile.fromPath(
              'xRayImage', // must match DTO field
              _image!.path,
              contentType: MediaType('image', _image!.path.split('.').last),
            ),
          );

    try {
      final res = await http.Response.fromStream(await req.send());
      setState(() => _uploading = false);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        _showResult(body['data']);
      } else {
        _snack('Upload failed (${res.statusCode})');
      }
    } catch (e) {
      setState(() => _uploading = false);
      _snack('Error: $e');
    }
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  void _showResult(Map<String, dynamic> d) {
    final conf = (d['confidence'] as num).toDouble();
    final result = d['result'] as String;
    final gradUrl = '${ApiConfig.baseUrl}${d['gradCamUrl']}';
    final hospitals = (d['recommendedHospitals'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Result: $result',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Confidence: ${(conf * 100).toStringAsFixed(2)} %'),
              const SizedBox(height: 12),
              Image.network(gradUrl, errorBuilder: (_, __, ___) {
                return const Text('Could not load Grad‑CAM image');
              }),
              if (hospitals != null && hospitals.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Recommended Hospitals:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ...hospitals.map((h) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(h['hospital'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                              '${h['province']} • ${h['distance_km']} km away'),
                        ],
                      ),
                    )),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close',
                      style: TextStyle(color: Color(0xFF1CA4AC))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = _image != null;
    final canSubmit = hasFile && !_uploading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => Profilepage())),
                  child: const Icon(Icons.arrow_back_ios_new_outlined,
                      color: Colors.black),
                ),
                const SizedBox(width: 20),
                const Text('Check X‑RAY',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
          ),
          const Text('Pneumonia Detection',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromRGBO(28, 164, 172, 1))),
          const SizedBox(height: 7),
          const Text(
            'AI powered analysis of chest x‑rays for rapid and accurate\npneumonia detection',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text('Upload file to check your report',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Image pick container
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 150,
              width: 170,
              decoration: BoxDecoration(
                color: const Color.fromARGB(90, 28, 165, 172),
                borderRadius: BorderRadius.circular(20),
                image: hasFile
                    ? DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: hasFile
                  ? null
                  : const Icon(Icons.upload_file,
                      size: 75, color: Colors.white),
            ),
          ),

          const SizedBox(height: 30),

          // Upload / Scan button
          InkWell(
            onTap: canSubmit ? _upload : null,
            child: Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                color: canSubmit ? const Color(0xFF1CA4AC) : Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: _uploading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text(
                        hasFile ? 'Scan' : 'Upload',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
