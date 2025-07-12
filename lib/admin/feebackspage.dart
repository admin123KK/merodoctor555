import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackItem {
  final int id;
  final String email;
  final String description;
  final DateTime created;

  FeedbackItem({
    required this.id,
    required this.email,
    required this.description,
    required this.created,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> j) => FeedbackItem(
        id: j['feedbackId'],
        email: j['email'],
        description: j['description'],
        created: DateFormat('yyyy-MM-dd hh:mm:ss a').parse(j['createdDate']),
      );
}

class FeedbacksPage extends StatefulWidget {
  const FeedbacksPage({Key? key}) : super(key: key);

  @override
  State<FeedbacksPage> createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  List<FeedbackItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<String?> _token() async =>
      (await SharedPreferences.getInstance()).getString('token');

  Future<void> _fetch() async {
    setState(() => _loading = true);
    final tok = await _token();
    if (tok == null) {
      _snack('Auth token missing');
      setState(() => _loading = false);
      return;
    }

    final res = await http.get(
      Uri.parse(ApiConfig.feedbacks),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tok',
      },
    );

    if (res.statusCode == 200) {
      final list = (jsonDecode(res.body)['data'] as List<dynamic>)
          .map((e) => FeedbackItem.fromJson(e))
          .toList();
      setState(() {
        _items = list;
        _loading = false;
      });
    } else {
      _snack('Failed to load (${res.statusCode})');
      setState(() => _loading = false);
    }
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  String _fmt(DateTime dt) => DateFormat('yyyy‑MM‑dd  hh:mm a').format(dt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetch,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new, size: 27),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: Text('Feedbacks',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                        const Icon(Icons.feedback_outlined, size: 28),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _items.length,
                      itemBuilder: (context, i) {
                        final f = _items[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 6),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(f.email,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(f.description),
                                const SizedBox(height: 6),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    _fmt(f.created),
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
