import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Dblog extends StatefulWidget {
  const Dblog({super.key});

  @override
  State<Dblog> createState() => _DblogState();
}

class _DblogState extends State<Dblog> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  final List<Map<String, dynamic>> comments = [];
  String? editingId;
  String selectedCategory = "General";
  int likes = 0;
  int views = 0;

  File? _selectedImage;

  final List<String> categories = [
    "General",
    "Cardiology",
    "Wellness",
    "Pediatrics",
    "Nutrition",
  ];

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void addOrUpdateComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    if (editingId == null) {
      setState(() {
        comments.add({
          'id': const Uuid().v4(),
          'text': text,
          'timestamp': DateFormat('MMM d, h:mm a').format(DateTime.now()),
          'category': selectedCategory,
          'doctorName': 'Dr. John Doe',
          'title': _titleController.text.trim(),
          'image': _selectedImage,
        });
      });
    } else {
      setState(() {
        final index = comments.indexWhere((c) => c['id'] == editingId);
        if (index != -1) {
          comments[index]['text'] = text;
          comments[index]['category'] = selectedCategory;
          comments[index]['titile'] = _titleController.text.trim();
        }
        editingId = null;
      });
    }

    _commentController.clear();
  }

  void editComment(String id) {
    final comment = comments.firstWhere((c) => c['id'] == id);
    _commentController.text = comment['text'];
    setState(() {
      editingId = id;
    });
  }

  void deleteComment(String id) {
    setState(() {
      comments.removeWhere((c) => c['id'] == id);
      if (editingId == id) {
        editingId = null;
        _commentController.clear();
      }
    });
  }

  Widget buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedImage != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              _selectedImage!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          icon: const Icon(
            Icons.image,
            color: Colors.black,
          ),
          label: const Text(
            "Pick Image from Gallery",
            style: TextStyle(color: Color(0xFF1CA4AC)),
          ),
          onPressed: pickImageFromGallery,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    views++;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios)),
                const Text(
                  'Create Blog',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const Icon(Icons.more_vert)
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Blog Title',
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF1CA4AC),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFF1CA4AC))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color(0xFF1CA4AC), width: 2)),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                  labelText: "Select Category",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF1CA4AC),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF1CA4AC))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Color(0xFF1CA4AC), width: 2))),
              items: categories
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 15),
            buildMediaSection(),
            const SizedBox(height: 15),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(90, 28, 165, 172),
                borderRadius: BorderRadius.circular(11),
              ),
              child: TextField(
                controller: _commentController,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: editingId == null
                      ? "  Create a new blog post..."
                      : "Edit your post...",
                  labelStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      editingId == null ? Icons.post_add : Icons.check,
                      color: Colors.black,
                    ),
                    onPressed: addOrUpdateComment,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 5),
              child: Text(
                "Comments",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...comments.map((comment) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    leading: comment['image'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              comment['image'],
                              height: 100,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(comment['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(comment['text']),
                        Text('Doctor: ${comment['doctorName'] ?? 'N/A'}'),
                        Text('Category: ${comment['category'] ?? 'N/A'}'),
                        Text(comment['timestamp'],
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () => editComment(comment['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteComment(comment['id']),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
