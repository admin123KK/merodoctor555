import 'package:flutter/material.dart';

class BlogDetailsPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;
  final String doctorName;
  final String time;
  final String category;

  const BlogDetailsPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.doctorName,
    required this.time,
    required this.category,
  });

  @override
  State<BlogDetailsPage> createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
  bool isLiked = false;
  final List<String> comments = [];
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      setState(() {
        comments.add(comment);
        _commentController.clear();
      });
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
              child: Image.asset(widget.imagePath, fit: BoxFit.cover),
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
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
                const Text('Like this post'),
              ],
            ),
            const Divider(height: 30),
            const Text('Comments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            for (final comment in comments)
              ListTile(
                leading: const Icon(Icons.comment),
                title: Text(comment),
              ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Write a comment...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
