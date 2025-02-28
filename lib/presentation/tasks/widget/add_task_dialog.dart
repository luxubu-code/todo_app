import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/tasks/tasks_cubit.dart';
import 'package:todo/bloc/tasks/tasks_state.dart';
import 'package:todo/data/models/tasks.dart';
import 'package:todo/presentation/tasks/widget/task_from.dart';

// Widget chính
class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController();
  late final _descriptionController = TextEditingController();
  bool _isRepeat = false;
  DateTime? _selectedDueDate;
  TimeOfDay? _selectedNotificationTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Hàm lấy thời gian đầy đủ đã được sửa đổi
  DateTime? _getFormattedDateTime() {
    if (_selectedDueDate == null) return null;
    return DateTime(
      _selectedDueDate!.year,
      _selectedDueDate!.month,
      _selectedDueDate!.day,
      23,
      59,
    );
  }

  // Hàm chọn ngày hạn chót
  Future<void> _selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) setState(() => _selectedDueDate = pickedDate);
  }

  // Hàm chọn giờ thông báo
  Future<void> _selectNotificationTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedNotificationTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null)
      setState(() => _selectedNotificationTime = pickedTime);
  }

  // Nút hành động
  Widget _buildActions() {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Hủy", style: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final dueDateTime = _getFormattedDateTime();
                  context.read<TasksCubit>().addTasks(
                    Tasks(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      created_at: DateTime.now(),
                      due_date: dueDateTime,
                      status: 'Đang hoàn thành',
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                "Lưu Task",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[900],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Thêm Công Việc",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TaskForm(
              formKey: _formKey,
              titleController: _titleController,
              descriptionController: _descriptionController,
              isRepeat: _isRepeat,
              onRepeatChanged: (value) => setState(() => _isRepeat = value),
              dueDate: _selectedDueDate,
              onDueDateTap: _selectDueDate,
              notificationTime: null,
              onNotificationTimeTap: () {},
            ),
            const SizedBox(height: 10),
            _buildActions(),
          ],
        ),
      ),
    );
  }
}
