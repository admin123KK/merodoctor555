import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationItem {
  final int id;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json['notificationId'],
        message: json['message'],
        isRead: json['isRead'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}

class Amessage extends StatefulWidget {
  const Amessage({Key? key}) : super(key: key);

  @override
  State<Amessage> createState() => _AmessageState();
}

class _AmessageState extends State<Amessage> {
  List<NotificationItem> _items = [];
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
      Uri.parse(ApiConfig.notification),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tok',
      },
    );

    if (res.statusCode == 200) {
      final list = (jsonDecode(res.body)['data'] as List<dynamic>)
          .map((e) => NotificationItem.fromJson(e))
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

  String _fmt(DateTime dt) => DateFormat('yyyy‑MM‑dd  HH:mm').format(dt);

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
                          child: Text('Notification',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                        const Icon(Icons.more_vert_outlined, size: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _items.length,
                      itemBuilder: (context, i) {
                        final n = _items[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 6),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: n.isRead
                                  ? Colors.white
                                  : const Color.fromARGB(90, 28, 165, 172),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 0.8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    n.message,
                                    style: TextStyle(
                                      fontWeight: n.isRead
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _fmt(n.createdAt),
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
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
