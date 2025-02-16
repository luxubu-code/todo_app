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
  }  @override
  void initState() {
    super.initState();
    // Tải danh sách categories khi màn hình được khởi tạo
    context.read<CategoriesCubit>().getCategories();
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm nhóm công việc'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
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
            onPressed: () {
              _addCategory();
            },
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
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Text('Đã xảy ra lỗi: ${state.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          }

          final categories = state.categories;

          if (categories.isEmpty) {
            return const Center(
              child: Text('Chưa có nhóm công việc nào. Hãy thêm nhóm mới!'),
            );
          }

          return Column(
            children: [
              // Dropdown chọn nhóm
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<Categories>(
                    value: _selectedCategory,
                    hint: const Text('Chọn nhóm công việc'),
                    isExpanded: true,
                    underline: Container(), // Ẩn đường gạch chân
                    onChanged: (category) {
                      if (category != null) {
                        _selectCategory(category);
                      }
                    },
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color((category.color ?? Colors.blue) as int),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              category.title ?? 'Không có tên',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Danh sách các nhóm
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(Colors.white as int),
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Text(
                          category.title ?? 'Không có tên',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'ID: ${category.id}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // TODO: Thêm chức năng sửa
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // TODO: Thêm chức năng xóa
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
