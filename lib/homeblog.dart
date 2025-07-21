import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
  bool isLikedByUser; // NEW FIELD to reflect if current user liked this blog

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
      isLikedByUser: json['isLikedByUser'] ?? false, // Parse new field
    );
  }
}

class Homeblog extends StatefulWidget {
  const Homeblog({super.key});

  @override
  State<Homeblog> createState() => _HomeblogState();
}

class _HomeblogState extends State<Homeblog> {
  List<Blog> blogs = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fetch blogs from API with isLikedByUser included in response
  Future<void> fetchBlogs() async {
    setState(() => isLoading = true);
    final token = await _getToken();
    if (token == null) return;
    final url = Uri.parse(ApiConfig.blogGetAll);
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final blogsJson = jsonResponse['data']['blogs'] as List<dynamic>;
          setState(() {
            blogs = blogsJson.map((b) => Blog.fromJson(b)).toList();
          });
        }
      }
    } catch (e) {}
    setState(() => isLoading = false);
  }

  // Toggle like and update isLikedByUser accordingly
  Future<void> toggleLike(Blog blog) async {
    final token = await _getToken();
    if (token == null) return;

    final url = Uri.parse(ApiConfig.toggleLike);
    final body = {"blogId": blog.blogId};

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
            blog.totalLikes -= 1;
            blog.isLikedByUser = false;
          } else {
            blog.totalLikes += 1;
            blog.isLikedByUser = true;
          }
        });
      }
    } catch (e) {}
  }

  Future<List<Map<String, dynamic>>> fetchComments(Blog blog) async {
    final token = await _getToken();
    if (token == null) return [];
    final url = Uri.parse(
        '${ApiConfig.baseUrl}/api/BlogComments/ByBlog/${blog.blogId}');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as List<dynamic>;
          return data
              .map<Map<String, dynamic>>((json) => {
                    'blogCommentId': json['blogCommentId'],
                    'blogId': json['blogId'],
                    'comment': json['comment'],
                    'name': json['name'],
                    'createdDate': json['createdDate'],
                  })
              .toList();
        }
      }
    } catch (e) {}
    return [];
  }

  Future<void> addComment(Blog blog, String commentText) async {
    final token = await _getToken();
    if (token == null) return;
    final url = Uri.parse(ApiConfig.addCommentUrl);
    final body = {"blogId": blog.blogId, "comment": commentText};
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
          blog.totalComments += 1;
        });
      }
    } catch (e) {}
  }

  void _showCommentsSheet(Blog blog) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlogCommentsBottomSheet(
        blog: blog,
        fetchComments: fetchComments,
        addComment: addComment,
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Blogs',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : blogs.isEmpty
              ? const Center(child: Text('No Blogs Found.'))
              : ListView.builder(
                  itemCount: blogs.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final blog = blogs[index];
                    String imageUrl = blog.blogPictureUrl.isNotEmpty
                        ? (blog.blogPictureUrl.startsWith('http')
                            ? blog.blogPictureUrl
                            : ApiConfig.baseUrl + blog.blogPictureUrl)
                        : 'assets/image/startpage1.png';
                    return Card(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Blog Header
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: (blog.profilePicture !=
                                              null &&
                                          blog.profilePicture!.isNotEmpty)
                                      ? (blog.profilePicture!.startsWith('http')
                                          ? NetworkImage(blog.profilePicture!)
                                          : NetworkImage(ApiConfig.baseUrl +
                                              blog.profilePicture!))
                                      : const AssetImage(
                                              'assets/image/startpage3.png')
                                          as ImageProvider,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(blog.doctorName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(blog.categoryName,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700)),
                                    ],
                                  ),
                                ),
                                Text(
                                    DateFormat('MMM d, h:mm a').format(
                                        DateTime.tryParse(blog.createdDate) ??
                                            DateTime.now()),
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey[500])),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(blog.title,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(blog.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[850])),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: imageUrl.startsWith('http')
                                  ? Image.network(imageUrl,
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover)
                                  : Image.asset(imageUrl,
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => toggleLike(blog),
                                  borderRadius: BorderRadius.circular(30),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Icon(
                                      blog.isLikedByUser
                                          ? Icons.thumb_up_alt
                                          : Icons.thumb_up_alt_outlined,
                                      color: blog.isLikedByUser
                                          ? Colors.blue
                                          : Colors.blue[700],
                                      size: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Text('${blog.totalLikes}',
                                    style: const TextStyle(fontSize: 15)),
                                const SizedBox(width: 18),
                                InkWell(
                                  onTap: () => _showCommentsSheet(blog),
                                  borderRadius: BorderRadius.circular(30),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Icon(Icons.comment_outlined,
                                        color: Colors.green[700], size: 22),
                                  ),
                                ),
                                const SizedBox(width: 18),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class BlogCommentsBottomSheet extends StatefulWidget {
  final Blog blog;
  final Future<List<Map<String, dynamic>>> Function(Blog) fetchComments;
  final Future<void> Function(Blog, String) addComment;

  const BlogCommentsBottomSheet({
    required this.blog,
    required this.fetchComments,
    required this.addComment,
    Key? key,
  }) : super(key: key);

  @override
  State<BlogCommentsBottomSheet> createState() =>
      _BlogCommentsBottomSheetState();
}

class _BlogCommentsBottomSheetState extends State<BlogCommentsBottomSheet> {
  List<Map<String, dynamic>> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  bool isLoadingComments = false;
  bool isPosting = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() => isLoadingComments = true);
    List<Map<String, dynamic>> fetched =
        await widget.fetchComments(widget.blog);
    setState(() {
      _comments = fetched;
      isLoadingComments = false;
    });
  }

  Future<void> _postComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() => isPosting = true);
    await widget.addComment(widget.blog, text);
    _commentController.clear();
    await _loadComments();
    setState(() => isPosting = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeInOut,
      padding: EdgeInsets.only(
          left: 0,
          top: 10,
          right: 0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
                child: Padding(
              padding: EdgeInsets.only(top: 6, bottom: 4),
              child: SizedBox(
                  height: 5,
                  width: 54,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.comment_outlined, color: Colors.black38),
                  const SizedBox(width: 9),
                  Text('Comments',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadComments,
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            isLoadingComments
                ? const Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 18.0),
                        child: CircularProgressIndicator()))
                : Expanded(
                    child: _comments.isEmpty
                        ? const Center(child: Text('No comments yet.'))
                        : ListView.builder(
                            itemCount: _comments.length,
                            itemBuilder: (context, idx) {
                              final comment = _comments[idx];
                              final name = comment['name'] ?? "User";
                              final msg = comment['comment'] ?? "";
                              final time = comment['createdDate'] ?? "";
                              return ListTile(
                                leading: const Icon(Icons.account_circle,
                                    size: 40, color: Colors.grey),
                                title: Text(name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(msg),
                                trailing: Text(
                                  DateFormat('MMM d, h:mm a').format(
                                      DateTime.tryParse(time) ??
                                          DateTime.now()),
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                              );
                            }),
                  ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 3),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLines: 3,
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: "Write a comment...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                      ),
                    ),
                  ),
                  isPosting
                      ? Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send_rounded,
                              color: Color(0xFF1CA4AC)),
                          onPressed: _postComment,
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
