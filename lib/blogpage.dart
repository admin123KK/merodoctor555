import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogDetailsPage extends StatefulWidget {
  final int blogId; // Added to fetch comments/likes properly
  final String imagePath;
  final String title;
  final String description;
  final String doctorName;
  final String time;
  final String category;
  final int totalLikes;

  const BlogDetailsPage({
    super.key,
    required this.blogId,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.doctorName,
    required this.time,
    required this.category,
    required this.totalLikes,
  });

  @override
  State<BlogDetailsPage> createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
  bool isLiked =
      false; // you can also fetch initial like status from backend if needed
  late int totalLikes;
  List<Map<String, dynamic>> comments = []; // hold comment objects

  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    totalLikes = widget.totalLikes;
    fetchComments();
    checkIfLiked();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchComments() async {
    final token = await _getToken();
    if (token == null) return;

    final url =
        Uri.parse(ApiConfig.getCommentsByBlog(widget.blogId.toString()));
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as List<dynamic>;
          setState(() {
            comments = data
                .map<Map<String, dynamic>>((json) => {
                      'blogCommentId': json['blogCommentId'],
                      'blogId': json['blogId'],
                      'comment': json['comment'],
                      'name': json['name'],
                      'createdDate': json['createdDate'],
                    })
                .toList();
          });
        }
      } else {
        print('Failed to fetch comments: ${response.body}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> addComment(String commentText) async {
    final token = await _getToken();
    if (token == null) return;

    final url = Uri.parse(ApiConfig.addCommentUrl);
    final body = {
      "blogId": widget.blogId,
      "comment": commentText,
    };

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          setState(() {
            // Clear input and refresh comments
            _commentController.clear();
          });
          await fetchComments();
        } else {
          _showSnackBar(jsonResponse['message'] ?? 'Could not add comment');
        }
      } else {
        _showSnackBar('Failed to add comment, please try again');
      }
    } catch (e) {
      _showSnackBar('Error adding comment');
      print('Add comment error: $e');
    }
  }

  Future<void> toggleLike() async {
    final token = await _getToken();
    if (token == null) return;

    final url = Uri.parse(ApiConfig.toggleLike);
    final body = {
      "blogId": widget.blogId,
    };

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        setState(() {
          isLiked = !isLiked;
          totalLikes += isLiked ? 1 : -1;
        });
      } else {
        _showSnackBar(jsonResponse['message'] ?? 'Like toggle failed');
      }
    } catch (e) {
      _showSnackBar('Error toggling like');
      print('Toggle like error: $e');
    }
  }

  Future<void> checkIfLiked() async {
    // Optional: Implement backend call here to check if user already liked the blog
    // For now, we keep isLiked false;
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _submitComment() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;
    addComment(comment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour % 12 == 0 ? 12 : dt.hour % 12}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? "PM" : "AM"}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blog Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.imagePath.startsWith('http')
                  ? Image.network(widget.imagePath, fit: BoxFit.cover)
                  : Image.asset(widget.imagePath, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text(widget.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('${widget.doctorName} • ${widget.category} • ${widget.time}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(widget.description),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: toggleLike,
                ),
                Text('$totalLikes likes', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const Divider(height: 30),
            const Text('Comments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            for (final comment in comments)
              ListTile(
                leading: const Icon(Icons.comment),
                title: Text(comment['comment']),
                subtitle: Text(
                    '${comment['name']} • ${formatDate(comment['createdDate'])}',
                    style: const TextStyle(fontSize: 12)),
              ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Write a comment...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _submitComment,
                ),
              ),
              minLines: 1,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
