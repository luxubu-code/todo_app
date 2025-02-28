import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/data/models/tasks.dart';

class TaskItemScreen extends StatefulWidget {
  final Tasks tasks;

  const TaskItemScreen({super.key, required this.tasks});

  @override
  State<TaskItemScreen> createState() => _TaskItemScreenState();
}

class _TaskItemScreenState extends State<TaskItemScreen> {
  // Danh sách các tùy chọn cho menu
  List<String> options = ['Tìm', 'Ghim', 'Giao diện', 'Đặt lời nhắc', 'Xóa'];

  // Controller cho TextField
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller với giá trị từ tasks
    _titleController = TextEditingController(text: widget.tasks.title);
    _contentController = TextEditingController(text: widget.tasks.description);
  }

  @override
  void dispose() {
    // Giải phóng controllers khi widget bị hủy
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat('HH:mm dd/M/yyyy');
    final formattedTime = timeFormatter.format(widget.tasks.created_at!);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Xử lý sự kiện chia sẻ
              },
              child: Icon(Icons.share_rounded),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String choice) {
              // Xử lý các lựa chọn menu
              switch (choice) {
                case 'Tìm':
                  // Thêm logic tìm kiếm
                  break;
                case 'Ghim':
                  // Thêm logic ghim ghi chú
                  break;
                // Thêm các case khác
              }
            },
            itemBuilder: (BuildContext context) {
              return options.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  // Hiển thị thời gian và ngày tháng
                  Text(
                    formattedTime,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  Text(
                    ' | ',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),

                  // Hiển thị trạng thái
                  Text(
                    'trạng thái : ${widget.tasks.status}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            // Trường nhập tiêu đề
            TextField(
              controller: _titleController,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Tiêu đề',
              ),
              onChanged: (value) {
                // Cập nhật tiêu đề trong tasks
                setState(() {
                  widget.tasks.title = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Trường nhập nội dung
            Expanded(
              child: TextField(
                controller: _contentController,
                style: TextStyle(fontSize: 16),
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nội dung ghi chú...',
                ),
                onChanged: (value) {
                  // Cập nhật nội dung trong tasks
                  setState(() {
                    widget.tasks.description = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.check_circle_outline),
              onPressed: () {
                // Xử lý đánh dấu hoàn thành
              },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt_outlined),
              onPressed: () {
                // Xử lý thêm ảnh
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Xử lý chỉnh sửa
              },
            ),
            IconButton(
              icon: Icon(Icons.mic),
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
