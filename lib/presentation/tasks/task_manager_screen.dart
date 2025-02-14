import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/category/categories_cubit.dart';
import '../../bloc/category/categories_state.dart';
import '../../data/models/categories.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({Key? key}) : super(key: key);

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  Categories? _selectedCategory;
  Color _selectedColor = Colors.blue;
  final _titleController = TextEditingController();

  // Chọn category
  void _selectCategory(Categories category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  Future<void> _addCategory() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên nhóm công việc')),
      );
      return;
    }
    try {
      final categoriesCubit = context.read<CategoriesCubit>();
      await categoriesCubit.addCategories(
          _titleController.text, _selectedColor);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm nhóm công việc thành công')),
        );
      }
      _titleController.clear();
      _selectedColor = Colors.blue;
    } catch (e) {}
  }

  void _showColorPickerDialog() {
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.cyan,
      Colors.brown,
      Colors.indigo,
      Colors.lime,
      Colors.amber,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.grey,
      Colors.black,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn màu'),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black26, width: 2),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm nhóm công việc'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Tên nhóm'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Chọn màu: '),
                GestureDetector(
                  onTap: _showColorPickerDialog,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black26, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Công việc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCategoryDialog,
            tooltip: 'Thêm nhóm công việc',
          ),
        ],
      ),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
        final categories = state.categories;
        return Column(
          children: [
            if (categories.isNotEmpty)
              DropdownButton<Categories>(
                value: _selectedCategory,
                hint: const Text('Chọn nhóm công việc'),
                onChanged: (category) {
                  if (category != null) {
                    _selectCategory(category);
                  }
                },
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.title ?? 'Không có tên'),
                  );
                }).toList(),
              ),
          ],
        );
      }),
    );
  }
}
