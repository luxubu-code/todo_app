import 'package:flutter/material.dart';

import 'database/DatabaseHelper.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final databaseHelper = DatabaseHelper.instance;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> _addTask() async {
    try {
      final task = {
        'title': titleController.text,
        'description': descriptionController.text,
        'created_at': DateTime.now().toIso8601String(),
        'due_date': DateTime.now().toIso8601String(),
        'status': 'pending',
        'priority': '1',
      };

      final id = await databaseHelper.insertTask(task);
      if (id > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm task thành công!')),
        );
        titleController.clear();
        descriptionController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm Task Mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addTask,
              icon: Icon(Icons.add),
              label: Text('Thêm Task'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
