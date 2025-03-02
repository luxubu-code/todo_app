import 'package:flutter/material.dart';

import '../../widget/build_textfield.dart';

class TaskForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool isRepeat;
  final ValueChanged<bool> onRepeatChanged;
  final DateTime? dueDate;
  final VoidCallback onDueDateTap;
  final TimeOfDay? notificationTime;
  final VoidCallback onNotificationTimeTap;

  const TaskForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.isRepeat,
    required this.onRepeatChanged,
    required this.dueDate,
    required this.onDueDateTap,
    required this.notificationTime,
    required this.onNotificationTimeTap,
  });

  Widget _buildDateTimeContainer(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildTextField().buildTextField(
            titleController,
            "Tiêu đề",
            Icons.title,
          ),
          const SizedBox(height: 8),
          BuildTextField().buildTextField(
            descriptionController,
            "Mô tả",
            Icons.description,
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lặp lại công việc'),
                Switch(value: isRepeat, onChanged: onRepeatChanged),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onDueDateTap,
            child: _buildDateTimeContainer(
              Icons.calendar_today,
              dueDate == null
                  ? "Chọn ngày hết hạn (không bắt buộc)"
                  : "${dueDate!.day}/${dueDate!.month}/${dueDate!.year}",
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onNotificationTimeTap,
            child: _buildDateTimeContainer(
              Icons.access_time,
              notificationTime == null
                  ? "Chọn giờ thông báo (không bắt buộc)"
                  : "${notificationTime!.hour.toString().padLeft(2, '0')}:${notificationTime!.minute.toString().padLeft(2, '0')}",
            ),
          ),
        ],
      ),
    );
  }
}
