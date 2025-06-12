import 'package:flutter/material.dart';

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
      setState(() {
        comments.add({
          // 'id': const Uuid().v4(),
          'text': text,
          'timeStamp': DateTime.now().toString()
        });
      });
    } else {
      setState(() {
        final index = comments.indexWhere((c) => c['id'] == editingId);
        if (index != -1) {
          comments[index]['text'] = 'text';
        }
        editingId = null;
      });
    }
    _commentController.clear();
  }

  void editComments(String id) {
    final comment = comments.firstWhere((c) => c['id'] == id);
    _commentController.text = comment['text'];
    setState(() {
      editingId = id;
    });
  }

  void deleteComments(String id) {
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
    return const Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                ),
                Text(
                  'Create Blog',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Icon(Icons.more_vert)
              ],
            ),
          )
        ],
      ),
    );
  }
}
