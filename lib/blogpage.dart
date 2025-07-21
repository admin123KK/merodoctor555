import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Blog {
  final int blogId;
  final String title;
  final String? profilePicture;
  final String content;
  final String createdDate;
  final String categoryName;
  final String doctorName;
  final String blogPictureUrl;
  int totalLikes;
  int totalComments;
  bool isLikedByUser;

  Blog({
    required this.blogId,
    required this.title,
    this.profilePicture,
    required this.content,
    required this.createdDate,
    required this.categoryName,
    required this.doctorName,
    required this.blogPictureUrl,
    required this.totalLikes,
    required this.totalComments,
    required this.isLikedByUser,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['blogId'],
      title: json['title'],
      profilePicture: json['profilePicture'],
      content: json['content'],
      createdDate: json['createdDate'],
      categoryName: json['categoryName'],
      doctorName: json['doctorName'],
      blogPictureUrl: json['blogPictureUrl'],
      totalLikes: json['totalLikes'],
      totalComments: json['totalComments'] ?? 0,
      isLikedByUser: json['isLikedByUser'] ?? false,
    );
  }
}

class BlogDetailsPage extends StatefulWidget {
  final int blogId;
  final String imagePath;
  final String title;
  final String description;
  final String doctorName;
  final String time;
  final String category;
  final int totalLikes;
  final bool isLikedByUser;

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
    this.isLikedByUser = false,
  });

  @override
  State<BlogDetailsPage> createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
  late bool isLiked;
  late int totalLikes;
  List<Map<String, dynamic>> comments = [];
  final TextEditingController _commentController = TextEditingController();
  bool isPosting = false;
  bool isLoadingComments = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLikedByUser;
    totalLikes = widget.totalLikes;
    fetchComments();
    fetchIsLiked(); // Fetch fresh like status from backend
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchIsLiked() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final url =
          Uri.parse('${ApiConfig.baseUrl}/api/blogs/${widget.blogId}/isliked');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && mounted) {
          setState(() {
            isLiked = jsonResponse['data']['isLiked'] ?? isLiked;
          });
        }
      }
    } catch (_) {
      // Silent fail
    }
  }

  Future<void> fetchComments() async {
    final token = await _getToken();
    if (token == null) return;
    setState(() => isLoadingComments = true);

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
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
    setState(() => isLoadingComments = false);
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
      setState(() => isPosting = true);
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          _commentController.clear();
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
    } finally {
      setState(() => isPosting = false);
    }
  }

  Future<void> toggleLike() async {
    final token = await _getToken();
    if (token == null) return;

    final url = Uri.parse(ApiConfig.toggleLike);
    final body = {"blogId": widget.blogId};

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
          if (jsonResponse['message']
              .toString()
              .toLowerCase()
              .contains('unliked')) {
            isLiked = false;
            totalLikes -= 1;
          } else {
            isLiked = true;
            totalLikes += 1;
          }
        });
      } else {
        _showSnackBar(jsonResponse['message'] ?? 'Like toggle failed');
      }
    } catch (e) {
      _showSnackBar('Error toggling like');
      print('Toggle like error: $e');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _submitComment() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;
    addComment(comment);
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
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Detail',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                  color: isLiked ? Colors.blue : Colors.grey,
                  size: 30,
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
          if (isLoadingComments)
            const Center(child: CircularProgressIndicator())
          else if (comments.isEmpty)
            const Center(child: Text('No comments yet.'))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, idx) {
                final comment = comments[idx];
                final name = comment['name'] ?? "User";
                final msg = comment['comment'] ?? "";
                final time = comment['createdDate'] ?? "";
                return ListTile(
                  leading: const Icon(Icons.account_circle,
                      size: 40, color: Colors.grey),
                  title: Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(msg),
                  trailing: Text(formatDate(time),
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                );
              },
            ),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Write a comment...',
              suffixIcon: IconButton(
                  icon: const Icon(Icons.send), onPressed: _submitComment),
            ),
            minLines: 1,
            maxLines: 3,
          ),
        ]),
      ),
    );
  }
}
