import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogCategory {
  final int id;
  final String name;
  BlogCategory({required this.id, required this.name});
  factory BlogCategory.fromJson(Map j) =>
      BlogCategory(id: j['categoryId'], name: j['name']);
}

class BlogItem {
  final int id;
  final String title, content, categoryName, doctorName, createdDate;
  final String? imageUrl;
  final int totalLikes;

  BlogItem({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryName,
    required this.doctorName,
    required this.createdDate,
    this.imageUrl,
    required this.totalLikes,
  });

  factory BlogItem.fromJson(Map j) => BlogItem(
        id: j['blogId'],
        title: j['title'],
        content: j['content'],
        categoryName: j['categoryName'],
        doctorName: j['doctorName'],
        createdDate: j['createdDate'],
        imageUrl: j['blogPictureUrl'],
        totalLikes: j['totalLikes'] ?? 0,
      );
}

class BlogComment {
  final int blogCommentId;
  final int blogId;
  final String comment;
  final String name;
  final String createdDate;

  BlogComment({
    required this.blogCommentId,
    required this.blogId,
    required this.comment,
    required this.name,
    required this.createdDate,
  });

  factory BlogComment.fromJson(Map<String, dynamic> json) {
    return BlogComment(
      blogCommentId: json['BlogCommentId'],
      blogId: json['BlogId'],
      comment: json['Comment'],
      name: json['Name'],
      createdDate: json['CreatedDate'],
    );
  }
}

class Dblog extends StatefulWidget {
  const Dblog({super.key});
  @override
  State<Dblog> createState() => _DblogState();
}

class _DblogState extends State<Dblog> {
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  File? pickedImage;
  String? existingImageUrl;
  List<BlogCategory> categories = [];
  BlogCategory? selectedCategory;
  List<BlogItem> myBlogs = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadMyBlogs();
  }

  Future<String?> _token() async =>
      (await SharedPreferences.getInstance()).getString('token');

  Future<void> loadCategories() async {
    final t = await _token();
    if (t == null) {
      print("No auth token found!");
      return;
    }
    final resp = await http.get(
      Uri.parse(ApiConfig.categoryGetAll),
      headers: {'Authorization': 'Bearer $t'},
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body)['data'] as List;
      categories = data.map((e) => BlogCategory.fromJson(e)).toList();
      if (categories.isNotEmpty) selectedCategory = categories.first;
      setState(() {});
    } else {
      print('Failed to load categories: ${resp.statusCode}');
    }
  }

  Future<void> loadMyBlogs() async {
    final t = await _token();
    if (t == null) {
      print("No auth token found!");
      return;
    }
    final resp = await http.get(
      Uri.parse(ApiConfig.doctorBlogs),
      headers: {'Authorization': 'Bearer $t'},
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body)['data']['blogs'] as List;
      myBlogs = data.map((j) => BlogItem.fromJson(j)).toList();
      setState(() {});
    } else {
      print('Failed to load blogs: ${resp.statusCode}');
    }
  }

  Future<void> pickImage() async {
    final p = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (p != null) {
      setState(() {
        pickedImage = File(p.path);
        existingImageUrl = null;
      });
    }
  }

  Future<void> submit() async {
    final t = await _token();
    if (t == null) {
      showErrorDialog(context, "Authorization token not found.");
      return;
    }

    if (pickedImage == null) {
      showErrorDialog(context, "Image is required.");
      return;
    }

    final uri = Uri.parse(ApiConfig.blogAdd);
    final req = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $t'
      ..fields['title'] = titleCtrl.text
      ..fields['content'] = contentCtrl.text
      ..fields['categoryId'] = '${selectedCategory!.id}';

    req.files.add(
        await http.MultipartFile.fromPath('BlogPictureUrl', pickedImage!.path));

    try {
      final streamedResponse = await req.send();
      final resp = await http.Response.fromStream(streamedResponse);

      if (resp.statusCode == 200) {
        clearForm();
        loadMyBlogs();
      } else {
        String errorMessage = 'Failed to submit blog.';
        try {
          final errorJson = jsonDecode(resp.body);
          if (errorJson is Map && errorJson.containsKey('message')) {
            errorMessage = errorJson['message'];
          } else if (errorJson is Map && errorJson.containsKey('error')) {
            errorMessage = errorJson['error'];
          } else {
            errorMessage = resp.body.toString();
          }
        } catch (e) {
          errorMessage = "Unexpected error: ${resp.body}";
        }
        showErrorDialog(context, errorMessage);
      }
    } catch (e) {
      showErrorDialog(context, "Submission failed: $e");
    }
  }

  Future<void> update(
    int blogId,
    String title,
    String content,
    int categoryId,
    File? imageFile,
    BuildContext dialogContext,
  ) async {
    final t = await _token();
    if (t == null) {
      showErrorDialog(dialogContext, "Authorization token not found.");
      return;
    }
    if (imageFile == null) {
      showErrorDialog(dialogContext, "Please select an image when updating.");
      return;
    }

    final uri = Uri.parse(ApiConfig.blogUpdate);
    final req = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $t'
      ..fields['title'] = title
      ..fields['content'] = content
      ..fields['categoryId'] = '$categoryId'
      ..fields['blogId'] = '$blogId';

    req.files.add(
        await http.MultipartFile.fromPath('BlogPictureUrl', imageFile.path));

    try {
      final streamedResponse = await req.send();
      final resp = await http.Response.fromStream(streamedResponse);

      if (resp.statusCode == 200) {
        Navigator.of(dialogContext).pop(true);
      } else {
        String errorMessage = 'Failed to update blog.';
        try {
          final errorJson = jsonDecode(resp.body);
          if (errorJson is Map && errorJson.containsKey('message')) {
            errorMessage = errorJson['message'];
          } else if (errorJson is Map && errorJson.containsKey('error')) {
            errorMessage = errorJson['error'];
          } else {
            errorMessage = resp.body.toString();
          }
        } catch (e) {
          errorMessage = "Unexpected error: ${resp.body}";
        }
        showErrorDialog(dialogContext, errorMessage);
      }
    } catch (e) {
      showErrorDialog(dialogContext, "Update failed: $e");
    }
  }

  void clearForm() {
    titleCtrl.clear();
    contentCtrl.clear();
    pickedImage = null;
    existingImageUrl = null;
    setState(() {});
  }

  Future<void> deleteBlog(int id) async {
    final t = await _token();
    if (t == null) {
      print("No auth token found!");
      return;
    }
    final resp = await http.delete(
      Uri.parse(ApiConfig.blogDelete(id.toString())),
      headers: {'Authorization': 'Bearer $t'},
    );
    if (resp.statusCode == 200) loadMyBlogs();
  }

  Future<void> showEditDialog(BlogItem blog) async {
    final titleEditCtrl = TextEditingController(text: blog.title);
    final contentEditCtrl = TextEditingController(text: blog.content);
    BlogCategory? selectedCat = categories.isNotEmpty
        ? categories.firstWhere(
            (c) => c.name == blog.categoryName,
            orElse: () => categories.first,
          )
        : null;

    File? pickedEditImage;
    String? existingImageUrl = blog.imageUrl;

    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          Future<void> pickEditImage() async {
            final p =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (p != null) {
              pickedEditImage = File(p.path);
              existingImageUrl = null;
              setStateDialog(() {});
            }
          }

          return AlertDialog(
            title: Text('Edit Blog'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleEditCtrl,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  SizedBox(height: 8),
                  DropdownButton<BlogCategory>(
                    isExpanded: true,
                    value: selectedCat,
                    items: categories
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c.name)))
                        .toList(),
                    onChanged: (v) {
                      selectedCat = v;
                      setStateDialog(() {});
                    },
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: pickEditImage,
                    icon: Icon(Icons.image),
                    label: Text('Pick Image'),
                  ),
                  SizedBox(height: 8),
                  if (pickedEditImage != null)
                    Image.file(pickedEditImage!, height: 150),
                  if (pickedEditImage == null && existingImageUrl != null)
                    Image.network(ApiConfig.baseUrl + existingImageUrl!,
                        height: 150),
                  SizedBox(height: 8),
                  TextField(
                    controller: contentEditCtrl,
                    maxLines: 5,
                    decoration: InputDecoration(labelText: 'Content'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  await update(
                    blog.id,
                    titleEditCtrl.text,
                    contentEditCtrl.text,
                    selectedCat!.id,
                    pickedEditImage,
                    context,
                  );
                  loadMyBlogs();
                },
                child: Text('Update'),
              ),
            ],
          );
        });
      },
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Blog')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
              controller: titleCtrl,
              decoration: InputDecoration(labelText: 'Title')),
          const SizedBox(height: 8),
          DropdownButton<BlogCategory>(
              isExpanded: true,
              value: selectedCategory,
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              onChanged: (v) {
                selectedCategory = v;
                setState(() {});
              }),
          const SizedBox(height: 8),
          ElevatedButton.icon(
              onPressed: pickImage,
              icon: Icon(Icons.image),
              label: Text('Pick Image')),
          if (pickedImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.file(pickedImage!, height: 150),
            ),
          if (pickedImage == null && existingImageUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(ApiConfig.baseUrl + existingImageUrl!,
                  height: 150),
            ),
          const SizedBox(height: 8),
          TextField(
              controller: contentCtrl,
              maxLines: 5,
              decoration: InputDecoration(labelText: 'Content')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: submit, child: Text('Submit')),
          const Divider(),
          const SizedBox(height: 10),
          Text('My Blogs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...myBlogs.map(
            (b) => Card(
              child: ListTile(
                leading: b.imageUrl != null
                    ? Image.network(ApiConfig.baseUrl + b.imageUrl!,
                        width: 60, fit: BoxFit.cover)
                    : null,
                title: Text(b.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${b.categoryName} • ${b.createdDate}'),
                    Row(
                      children: [
                        Icon(Icons.thumb_up, color: Colors.purple, size: 15),
                        SizedBox(width: 4),
                        Text('${b.totalLikes} likes',
                            style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showEditDialog(b)),
                  IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteBlog(b.id)),
                ]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BlogDetailPage(blog: b)),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BlogDetailPage extends StatefulWidget {
  final BlogItem blog;
  const BlogDetailPage({super.key, required this.blog});

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  List<BlogComment> comments = [];
  bool loadingComments = true;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<String?> _token() async =>
      (await SharedPreferences.getInstance()).getString('token');

  Future<void> fetchComments() async {
    final token = await _token();
    if (token == null) {
      setState(() {
        loadingComments = false;
      });
      return;
    }

    final url =
        Uri.parse(ApiConfig.getCommentsByBlog(widget.blog.id.toString()));

    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] is List) {
          final data = jsonBody['data'] as List;
          comments = data.map((e) => BlogComment.fromJson(e)).toList();
        }
      }
    } catch (e) {
      // error handling: you can show message or ignore
    } finally {
      setState(() {
        loadingComments = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final blog = widget.blog;

    return Scaffold(
      appBar: AppBar(title: Text(blog.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (blog.imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ApiConfig.baseUrl + blog.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 18),
          ],
          Text(
            blog.title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Category: ${blog.categoryName}',
            style:
                TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            'By Dr. ${blog.doctorName} • ${blog.createdDate}',
            style:
                TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.thumb_up, color: Colors.purple, size: 20),
              SizedBox(width: 6),
              Text(
                '${blog.totalLikes} Likes',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Divider(height: 30),
          Text(blog.content, style: TextStyle(fontSize: 17)),
          SizedBox(height: 30),
          Text("Comments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          if (loadingComments)
            Center(child: CircularProgressIndicator())
          else if (comments.isEmpty)
            Text("No comments yet.")
          else
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final c = comments[index];
                return ListTile(
                  title: Text(c.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.comment),
                      SizedBox(height: 4),
                      Text(
                        c.createdDate,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
        ]),
      ),
    );
  }
}
