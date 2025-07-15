import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart'; // Adjust this import to point to your API config
import 'package:shared_preferences/shared_preferences.dart';

class Historyorsavedpage extends StatefulWidget {
  const Historyorsavedpage({super.key});

  @override
  State<Historyorsavedpage> createState() => _HistoryorsavedpageState();
}

class _HistoryorsavedpageState extends State<Historyorsavedpage> {
  List<dynamic> history = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchXrayHistory();
  }

  Future<void> fetchXrayHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse(ApiConfig.xrayHistory),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        history = data['data'];
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      print('Failed to load history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : history.isEmpty
                ? const Center(child: Text('No history available'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              '${ApiConfig.baseUrl}${item['xRayImageUrl']}',
                            ),
                            radius: 30,
                          ),
                          title: Text(item['result']),
                          subtitle: Text(
                              'Confidence: ${(item['confidence'] * 100).toStringAsFixed(1)}%\nDate: ${item['dateTime']}'),
                          trailing: TextButton(
                            child: const Text('Details'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Report Details'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Result: ${item['result']}'),
                                        Text(
                                            'Confidence: ${(item['confidence'] * 100).toStringAsFixed(2)}%'),
                                        Text('Date: ${item['dateTime']}'),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Grad-CAM Image:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Image.network(
                                          '${ApiConfig.baseUrl}${item['gradCamUrl']}',
                                          height: 150,
                                          errorBuilder: (_, __, ___) => const Text(
                                              'Could not load Grad-CAM image'),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          item['result'] == 'Normal'
                                              ? 'No hospital recommendation.'
                                              : 'Recommended: ${item['recommendedHospital']}',
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Close',
                                          style: TextStyle(
                                              color: Color(0xFF1CA4AC))),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
