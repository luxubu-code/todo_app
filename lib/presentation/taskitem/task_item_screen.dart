import 'package:flutter/material.dart';
import 'package:todo/data/models/tasks.dart';
import 'package:todo/presentation/taskitem/widget/build_app_bar.dart';
import 'package:todo/presentation/taskitem/widget/build_body_tasksitem.dart';

class TaskItemScreen extends StatefulWidget {
  final Tasks tasks;

  const TaskItemScreen({super.key, required this.tasks});

  @override
  State<TaskItemScreen> createState() => _TaskItemScreenState();
}

class _TaskItemScreenState extends State<TaskItemScreen> {
  // Controller cho TextField
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Tasks _currentTasks;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller với giá trị từ tasks
    _currentTasks = widget.tasks;
    _titleController = TextEditingController(text: _currentTasks.title);
    _contentController = TextEditingController(text: _currentTasks.description);
  }

  @override
  void dispose() {
    // Giải phóng controllers khi widget bị hủy
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Cập nhật tiêu đề
  void _updateTitle(String value) {
    setState(() {
      _currentTasks.title = value;
    });
  }

  // Cập nhật nội dung
  void _updateDescription(String value) {
    setState(() {
      _currentTasks.description = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: BuildAppBar().buildAppBar(context, _currentTasks),
      body: BuildBodyTasksitem().buildBodyTasksItem(
        _titleController,
        _contentController,
        _currentTasks,
        _updateTitle,
        _updateDescription,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: () {
                // Xử lý đánh dấu hoàn thành
              },
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () {
                // Xử lý thêm ảnh
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Xử lý chỉnh sửa
              },
            ),
            IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {
                // Xử lý ghi âm
              },
            ),
          ],
        ),
      ),
    );
  }
}
