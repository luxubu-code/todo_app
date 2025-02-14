import 'package:flutter/material.dart';
import 'package:todo/presentation/widget/build_textfield.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  double _x = 0, _y = 0;
  bool _initialized = false;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDueDate;
  String? _selectedPriority;
  String? _selectedType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final size = MediaQuery.of(context).size;
      _x = size.width * 0.85;
      _y = size.height * 0.6;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleDrag(DragUpdateDetails details) {
    setState(() {
      _x = (_x + details.delta.dx)
          .clamp(0, MediaQuery.of(context).size.width - 45);
      _y = (_y + details.delta.dy)
          .clamp(0, MediaQuery.of(context).size.height - 45);
    });
  }

  Future<void> _selectDueDate(StateSetter setDialogState) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setDialogState(() => _selectedDueDate = picked);
  }

  Widget _buildDropdown(
      String? hintText, List<String>? items, String? _selected) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.flag, color: Colors.white70),
        filled: true,
        fillColor: Colors.white
            .withOpacity(0.1), // Sử dụng withOpacity thay vì withValues
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: Colors.grey[900],
      value: _selected,
      items: items!
          .map((String value) => DropdownMenuItem(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              ))
          .toList(),
      onChanged: (newValue) {
        setState(() {
          _selected = newValue;
        });
      },
    );
  }

  Widget _buildTaskForm(StateSetter setDialogState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdown('Phân loại công việc',
              ['Việc nhà', 'Đi chợ', 'Đi làm'], _selectedPriority),
          const SizedBox(height: 8),
          BuildTextfield()
              .buildTextField(_titleController, "Tiêu đề", Icons.title),
          const SizedBox(height: 8),
          BuildTextfield().buildTextField(
              _descriptionController, "Mô tả", Icons.description,
              maxLines: 3),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => _selectDueDate(setDialogState),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(children: [
                const Icon(Icons.calendar_today, color: Colors.white70),
                const SizedBox(width: 10),
                Text(
                    _selectedDueDate == null
                        ? "Chọn ngày hết hạn"
                        : "${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}",
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ]),
            ),
          ),
          const SizedBox(height: 15),
          _buildDropdown(
              'Độ ưu tiên', ['Thấp', 'Trung bình', 'Cao'], _selectedPriority)
        ],
      ),
    );
  }

  Future<void> _showAddTaskDialog() async {
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
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
                    const Text("Thêm Công Việc",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTaskForm(setDialogState),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Hủy",
                            style: TextStyle(color: Colors.white70))),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Lưu Task",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onPanUpdate: (details) => _handleDrag(details),
        child: Container(
          height: 45,
          width: 45,
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: Colors.tealAccent.withOpacity(0.9),
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: IconButton(
            onPressed: _showAddTaskDialog,
            icon: const Icon(Icons.add_task, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
