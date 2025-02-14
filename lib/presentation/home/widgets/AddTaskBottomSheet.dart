import 'package:flutter/material.dart';

import '../../../data/models/tasks.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Function(Tasks) onTaskAdded;

  const AddTaskBottomSheet({
    Key? key,
    required this.onTaskAdded,
  }) : super(key: key);

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  // Controllers cho các text field
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Các giá trị mặc định cho task mới
  DateTime? _dueDate;
  int _status = 0; // Pending
  String _priority = 'Normal';
  String? _imagePath;

  // List các priority để người dùng chọn
  final List<String> _priorities = ['Low', 'Normal', 'High', 'Urgent'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 8,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thanh kéo thả ở đầu bottom sheet
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tiêu đề bottom sheet
            Text(
              'Thêm Task Mới',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Text field nhập tiêu đề
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 12),

            // Text field nhập mô tả
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 12),

            // Chọn ngày đến hạn
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(_dueDate == null
                  ? 'Chọn ngày đến hạn'
                  : 'Đến hạn: ${_dueDate?.day}/${_dueDate?.month}/${_dueDate?.year}'),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => _dueDate = date);
                }
              },
            ),

            // Chọn độ ưu tiên
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Độ ưu tiên',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.priority_high),
              ),
              value: _priority,
              items: _priorities.map((String priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _priority = newValue);
                }
              },
            ),
            const SizedBox(height: 12),

            // Nút thêm ảnh
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              label: Text('Thêm ảnh'),
              onPressed: () {
                // TODO: Implement image picker
              },
            ),
            const SizedBox(height: 16),

            // Nút lưu task
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Tạo task mới từ dữ liệu đã nhập
                final newTask = Tasks(
                  id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
                  title: _titleController.text,
                  description: _descriptionController.text,
                  created_at: DateTime.now(),
                  due_date: _dueDate,
                  status: _status,
                  priority: _priority,
                  image_path: _imagePath,
                );

                // Gọi callback để thêm task
                widget.onTaskAdded(newTask);

                // Đóng bottom sheet
                Navigator.pop(context);
              },
              child: Text('Lưu Task'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
