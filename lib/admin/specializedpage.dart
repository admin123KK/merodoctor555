import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/admin/ahomepage.dart';
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart'; // if you use it

// ─────────────────────────────────────────────────────────────
//  MODEL
// ─────────────────────────────────────────────────────────────
class Specialization {
  final int id;
  final String name;

  Specialization({required this.id, required this.name});

  factory Specialization.fromJson(Map<String, dynamic> json) =>
      Specialization(id: json['specializationId'], name: json['name']);

  Map<String, dynamic> toJson() => {'name': name};
}

// ─────────────────────────────────────────────────────────────
//  SERVICE  (adds Bearer token where needed)
// ─────────────────────────────────────────────────────────────
class _SpecializationService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // adapt to your key
  }

  Future<List<Specialization>> fetchAll() async {
    final res = await http.get(Uri.parse(ApiConfig.specializations));
    final list = (jsonDecode(res.body)['data'] as List<dynamic>);
    return list.map((e) => Specialization.fromJson(e)).toList();
  }

  Future<void> add(String name) async {
    final token = await _token();
    await http.post(Uri.parse(ApiConfig.addSpecialization),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name}));
  }

  Future<void> update(int id, String name) async {
    final token = await _token();
    await http.put(Uri.parse(ApiConfig.updateSpecialization(id.toString())),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name}));
  }

  Future<void> delete(int id) async {
    final token = await _token();
    await http.delete(Uri.parse(ApiConfig.deleteSpecialization(id.toString())),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        });
  }
}

// ─────────────────────────────────────────────────────────────
//  UI
// ─────────────────────────────────────────────────────────────
class SpecializationAdminPage extends StatefulWidget {
  const SpecializationAdminPage({Key? key}) : super(key: key);

  @override
  State<SpecializationAdminPage> createState() =>
      _SpecializationAdminPageState();
}

class _SpecializationAdminPageState extends State<SpecializationAdminPage> {
  final _svc = _SpecializationService();
  final _nameCtrl = TextEditingController();
  List<Specialization> _items = [];
  int? _editingId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      _items = await _svc.fetchAll();
    } finally {
      setState(() => _loading = false);
    }
  }

  void _openDialog({Specialization? existing}) {
    if (existing != null) {
      _editingId = existing.id;
      _nameCtrl.text = existing.name;
    } else {
      _editingId = null;
      _nameCtrl.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            _editingId == null ? 'Add Specialization' : 'Edit Specialization'),
        content: TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(labelText: 'Specialization Name'),
        ),
        actions: [
          TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel')),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              final name = _nameCtrl.text.trim();
              if (name.isEmpty) return;
              if (_editingId == null) {
                await _svc.add(name);
                _snack('Added');
              } else {
                await _svc.update(_editingId!, name);
                _snack('Updated');
              }
              Navigator.pop(context);
              await _refresh();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _delete(int id) async {
    await _svc.delete(id);
    _snack('Deleted');
    await _refresh();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          const SizedBox(height: 50),
          Row(children: [
            InkWell(
              onTap: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Ahomepage())),
              child: const Icon(Icons.arrow_back_ios_new),
            ),
            const SizedBox(width: 30),
            const Text('Manage Specialization',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Spacer(),
            IconButton(icon: const Icon(Icons.add), onPressed: _openDialog),
          ]),
          const SizedBox(height: 20),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: DataTable(
                        columnSpacing: 16,
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _items
                            .map((s) => DataRow(cells: [
                                  DataCell(Text(s.name)),
                                  DataCell(Row(children: [
                                    IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Color(0xFF1CA4AC)),
                                        onPressed: () =>
                                            _openDialog(existing: s)),
                                    IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _delete(s.id)),
                                  ])),
                                ]))
                            .toList(),
                      ),
                    ),
                  ),
                ),
        ]),
      ),
    );
  }
}
