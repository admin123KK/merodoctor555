import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/admin/ahomepage.dart';
import 'package:merodoctor/api.dart'; // ApiConfig (edited below)
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────
// ApiConfig — make sure these constants exist exactly like this
// ─────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────
class BlogCategory {
  final int id;
  final String name;

  BlogCategory({required this.id, required this.name});

  factory BlogCategory.fromJson(Map<String, dynamic> json) => BlogCategory(
        id: json['categoryId'] ?? json['blogCategoryId'], // tolerate either key
        name: json['name'],
      );
}

// ─────────────────────────────────────────────────────────────
// SERVICE
// ─────────────────────────────────────────────────────────────
class _BlogCategoryService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // adjust to your key
  }

  // GET ------------------------------------------------------
  Future<List<BlogCategory>> fetchAll() async {
    final res = await http.get(Uri.parse(ApiConfig.categories));
    if (res.statusCode != 200) {
      throw Exception('Fetch failed (${res.statusCode})');
    }
    final list = (jsonDecode(res.body)['data'] as List<dynamic>);
    return list.map((e) => BlogCategory.fromJson(e)).toList();
  }

  // POST -----------------------------------------------------
  Future<void> add(String name) async {
    final tok = await _token();
    final res = await http.post(
      Uri.parse(ApiConfig.addCategory),
      headers: {
        'Content-Type': 'application/json',
        if (tok != null) 'Authorization': 'Bearer $tok',
      },
      body: jsonEncode({'name': name}),
    );
    if (res.statusCode != 200) {
      throw Exception('Add failed (${res.statusCode})');
    }
  }

  // PUT ------------------------------------------------------
  Future<void> update(int id, String name) async {
    final tok = await _token();
    final res = await http.put(
      Uri.parse(ApiConfig.updateCategory), // no /{id}
      headers: {
        'Content-Type': 'application/json',
        if (tok != null) 'Authorization': 'Bearer $tok',
      },
      body: jsonEncode({'categoryId': id, 'name': name}),
    );
    if (res.statusCode != 200) {
      throw Exception('Update failed (${res.statusCode})');
    }
  }

  // DELETE ---------------------------------------------------
  Future<void> delete(int id) async {
    final tok = await _token();
    final res = await http.delete(
      Uri.parse(ApiConfig.deleteCategory(id.toString())),
      headers: {if (tok != null) 'Authorization': 'Bearer $tok'},
    );
    if (res.statusCode != 200) {
      throw Exception('Delete failed (${res.statusCode})');
    }
  }
}

// ─────────────────────────────────────────────────────────────
// UI
// ─────────────────────────────────────────────────────────────
class BlogCategoryAdminPage extends StatefulWidget {
  const BlogCategoryAdminPage({super.key});

  @override
  State<BlogCategoryAdminPage> createState() => _BlogCategoryAdminPageState();
}

class _BlogCategoryAdminPageState extends State<BlogCategoryAdminPage> {
  final _svc = _BlogCategoryService();
  final _nameCtrl = TextEditingController();
  List<BlogCategory> _items = [];
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
    } catch (e) {
      _snack('Error loading categories');
    } finally {
      setState(() => _loading = false);
    }
  }

  // add / edit dialog ---------------------------------------
  void _openDialog({BlogCategory? existing}) {
    _editingId = existing?.id;
    _nameCtrl.text = existing?.name ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            _editingId == null ? 'Add Blog Category' : 'Edit Blog Category'),
        content: TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(labelText: 'Category Name'),
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
              Navigator.pop(context);

              try {
                if (_editingId == null) {
                  await _svc.add(name);
                  _snack('Category added');
                } else {
                  await _svc.update(_editingId!, name);
                  _snack('Category updated');
                }
                await _refresh();
              } catch (e) {
                _snack('Save failed');
              }
            },
          ),
        ],
      ),
    );
  }

  // delete confirm ------------------------------------------
  Future<void> _delete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Delete this category?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await _svc.delete(id);
      _snack('Deleted');
      await _refresh();
    } catch (_) {
      _snack('Delete failed');
    }
  }

  // snack helper --------------------------------------------
  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  // build ----------------------------------------------------
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
            const Text('Manage Blog Categories',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Spacer(),
            IconButton(icon: const Icon(Icons.add), onPressed: _openDialog),
          ]),
          const SizedBox(height: 20),
          _loading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _items
                            .map((c) => DataRow(cells: [
                                  DataCell(Text(c.name)),
                                  DataCell(Row(children: [
                                    IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Color(0xFF1CA4AC)),
                                        onPressed: () =>
                                            _openDialog(existing: c)),
                                    IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _delete(c.id)),
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
