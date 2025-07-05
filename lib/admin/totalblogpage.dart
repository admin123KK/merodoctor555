import 'package:flutter/material.dart';

class AdminBlogPage extends StatefulWidget {
  const AdminBlogPage({super.key});

  @override
  State<AdminBlogPage> createState() => _AdminBlogPageState();
}

class _AdminBlogPageState extends State<AdminBlogPage> {
  List<Map<String, String>> blogs = [
    {
      'title': 'Healthy Diet Tips',
      'description': 'Learn how to maintain a healthy diet...',
    },
    {
      'title': 'Mental Health Awareness',
      'description': 'Understanding mental health in daily life...',
    },
  ];

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _showBlogDialog({int? index}) {
    if (index != null) {
      _titleController.text = blogs[index]['title']!;
      _descController.text = blogs[index]['description']!;
    } else {
      _titleController.clear();
      _descController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? 'Add Blog' : 'Edit Blog'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isEmpty || _descController.text.isEmpty)
                return;

              setState(() {
                if (index == null) {
                  blogs.add({
                    'title': _titleController.text,
                    'description': _descController.text,
                  });
                } else {
                  blogs[index] = {
                    'title': _titleController.text,
                    'description': _descController.text,
                  };
                }
              });

              Navigator.pop(context);
            },
            child: Text(index == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _deleteBlog(int index) {
    setState(() {
      blogs.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Blogs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showBlogDialog(),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(blogs[index]['title']!),
              subtitle: Text(blogs[index]['description']!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showBlogDialog(index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteBlog(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
