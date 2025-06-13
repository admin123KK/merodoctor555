import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Dblog extends StatefulWidget {
  const Dblog({super.key});

  @override
  State<Dblog> createState() => _DblogState();
}

class _DblogState extends State<Dblog> {
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> comments = [];
  String? editingId;

  void addOrUpdateComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    if (editingId == null) {
      // Add new comment
      setState(() {
        comments.add({
          'id': const Uuid().v4(),
          'text': text,
          'timestamp': DateFormat('MMM d, h:mm a').format(DateTime.now()),
        });
      });
    } else {
      // Update existing comment
      setState(() {
        final index = comments.indexWhere((c) => c['id'] == editingId);
        if (index != -1) {
          comments[index]['text'] = text;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back_ios),
                Text(
                  'Create Blog',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Icon(Icons.more_vert)
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    90,
                    28,
                    165,
                    172,
                  ),
                  borderRadius: BorderRadius.circular(11)),
              child: TextField(
                cursorColor: Colors.grey,
                controller: _commentController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: editingId == null
                      ? "  Create a new blog post..."
                      : "Edit your post...",
                  labelStyle: TextStyle(color: Colors.grey),
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
            Expanded(
              child: comments.isEmpty
                  ? const Center(child: Text("No comments yet."))
                  : ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          iconColor: Colors.blueGrey,
                          title: Text(
                            comment['text'],
                          ),
                          subtitle: Text(comment['timestamp']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                                onPressed: () => editComment(comment['id']),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteComment(comment['id']),
                              ),
                            ],
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
