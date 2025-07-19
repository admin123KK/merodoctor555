import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorNotificationItem {
  final int id;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  DoctorNotificationItem({
    required this.id,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory DoctorNotificationItem.fromJson(Map<String, dynamic> json) =>
      DoctorNotificationItem(
        id: json['notificationId'],
        message: json['message'],
        isRead: json['isRead'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}

class Dmessage extends StatefulWidget {
  const Dmessage({super.key});

  @override
  State<Dmessage> createState() => _DmessageState();
}

class _DmessageState extends State<Dmessage> {
  List<DoctorNotificationItem> _items = [];
  bool _loading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();

    // Auto-refresh every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchNotifications(showLoader: false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<String?> _token() async =>
      (await SharedPreferences.getInstance()).getString('token');

  Future<void> _fetchNotifications({bool showLoader = true}) async {
    if (showLoader) setState(() => _loading = true);

    final tok = await _token();
    if (tok == null) {
      _snack('Token missing');
      if (showLoader) setState(() => _loading = false);
      return;
    }

    try {
      final res = await http.get(
        Uri.parse(ApiConfig.notification),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tok',
        },
      );

      if (res.statusCode == 200) {
        final list = (jsonDecode(res.body)['data'] as List<dynamic>)
            .map((e) => DoctorNotificationItem.fromJson(e))
            .toList();
        setState(() {
          _items = list;
          _loading = false;
        });
      } else {
        _snack('Failed to load (${res.statusCode})');
        if (showLoader) setState(() => _loading = false);
      }
    } catch (e) {
      print('Error during fetch: $e');
      _snack('Error fetching notifications');
      if (showLoader) setState(() => _loading = false);
    }
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  String _fmt(DateTime dt) => DateFormat('yyyy-MM-dd  HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchNotifications,
              child: Column(
                children: [
                  const SizedBox(height: 55),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios, size: 27),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        const Icon(Icons.more_vert, size: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _items.isEmpty
                        ? const Center(
                            child: Text(
                              'No notifications',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              final n = _items[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 6),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: n.isRead
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            90, 28, 165, 172),
                                    borderRadius: BorderRadius.circular(13),
                                    border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 0.8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
