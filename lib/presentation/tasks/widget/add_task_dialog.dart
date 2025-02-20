import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/tasks/tasks_cubit.dart';
import 'package:todo/bloc/tasks/tasks_state.dart';
import 'package:todo/presentation/widget/build_textfield.dart';

import '../../../data/models/tasks.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController();
  late final _descriptionController = TextEditingController();
  DateTime? _selectedDueDate;
  TimeOfDay? _selectedDueTime;
  String? _selectedType;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            _buildTaskForm(),
            const SizedBox(height: 10),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  // Hàm chọn ngày
  Future<void> _selectDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
      });
    }
  }

  // Hàm chọn giờ
  Future<void> _selectDueTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDueTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedDueTime = pickedTime;
      });
    }
  }

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
                try {
                  print('ấn lưu tasks');
                  if (_formKey.currentState!.validate()) {
                    DateTime? dueDateTime;
                    if (_selectedDueDate != null && _selectedDueTime != null) {
                      dueDateTime = DateTime(
                        _selectedDueDate!.year,
                        _selectedDueDate!.month,
                        _selectedDueDate!.day,
                        _selectedDueTime!.hour,
                        _selectedDueTime!.minute,
                      );
                    }

                    // Thêm task mới
                    context.read<TasksCubit>().addTasks(
                      Tasks(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        created_at: DateTime.now(),
                        due_date: dueDateTime,
                        status: 'pending',
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                } catch (e) {
                  print('ấn lưu tasks');
                  throw Exception('lỗi khi ấnlưu tasks ${e}');
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

  Widget _buildTaskForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CustomDropdown(
          //   hintText: 'Phân loại công việc',
          //   items: ['Việc nhà', 'Đi chợ', 'Đi làm'],
          //   onValueChanged: (value) {
          //     _selectedType = value;
          //   },
          // ),
          // const SizedBox(height: 8),
          BuildTextfield().buildTextField(
            _titleController,
            "Tiêu đề",
            Icons.title,
          ),
          const SizedBox(height: 8),
          BuildTextfield().buildTextField(
            _descriptionController,
            "Mô tả",
            Icons.description,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _selectDueDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white70),
                  const SizedBox(width: 10),
                  Text(
                    _selectedDueDate == null
                        ? "Chọn ngày hết hạn"
                        : "${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _selectDueTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white70),
                  const SizedBox(width: 10),
                  Text(
                    _selectedDueTime == null
                        ? "Chọn giờ"
                        : "${_selectedDueTime!.hour}:${_selectedDueTime!.minute}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
