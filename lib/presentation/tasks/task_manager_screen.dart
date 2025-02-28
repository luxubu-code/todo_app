import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/presentation/tasks/widget/add_task_dialog.dart';
import 'package:todo/presentation/tasks/widget/build_task_item.dart';

import '../../bloc/navigation/navigation_cubit.dart';
import '../../bloc/tasks/tasks_cubit.dart';
import '../../bloc/tasks/tasks_state.dart';
import '../../config/routes/app_routes.dart';
import '../taskitem/task_item_screen.dart';
import '../widget/build_context_menu.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({Key? key}) : super(key: key);

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final List<String> _menuOptions = [
    'Sửa',
    'Chế độ xem',
    'Sắp xếp theo thời gian tạo',
    'Sắp xếp theo thời gian sửa',
  ];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load danh sách tasks
  void _loadTasks() {
    context.read<TasksCubit>().getTasks();
  }

  void _handleCheckboxChanged(int id) async {
    context.read<TasksCubit>().selectTasks(id);
    print('ấn _handleCheckboxChange ');
  }

  Future<void> _showAddTaskDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );

    if (result == true) {
      _loadTasks();
    }
  }

  // Xử lý các tùy chọn từ menu
  Future<void> _handleOptionSelected(
    BuildContext context,
    String option,
  ) async {
    switch (option) {
      case 'Sửa':
        context.read<NavigationCubit>().toggleFix();
        setState(() {
          if (context.read<NavigationCubit>().state) {
            context.read<TasksCubit>().clearTasksSelect();
          }
        });
        break;
      case 'Chế độ xem':
        _showViewModeDialog();
        break;
      case 'Sắp xếp theo thời gian tạo':
        break;
      case 'Sắp xếp theo thời gian sửa':
        break;
    }
  }

  void _showViewModeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: const Text('Chọn chế độ xem'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã chọn chế độ xem danh sách'),
                    ),
                  );
                },
                child: const Text('Danh sách'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã chọn chế độ xem lưới')),
                  );
                },
                child: const Text('Lưới'),
              ),
            ],
          ),
    );
  }

  void selectAllOrClear(bool isAllSelected) {
    if (isAllSelected) {
      context.read<TasksCubit>().clearTasksSelect();
      print('Bỏ chọn tất cả');
    } else {
      context.read<TasksCubit>().selectAllTask(true);
      print('Chọn tất cả');
    }
  }

  List<Widget> _buildNormalAppBarActions() {
    return [
      IconButton(
        icon: const Icon(Icons.more_vert, size: 24),
        onPressed: () {
          final RenderBox button = context.findRenderObject() as RenderBox;
          final menuBuilder = BuildContextMenu(
            options: _menuOptions,
            onSelect: (option) => _handleOptionSelected(context, option),
          );
          menuBuilder.showContextMenu(context, button);
        },
      ),
    ];
  }

  // Xây dựng các actions cho AppBar chế độ sửa
  List<Widget> _buildEditAppBarActions() {
    bool isAllSelected = context.read<TasksCubit>().isAllSelected;

    return [
      TextButton.icon(
        onPressed: () => selectAllOrClear(isAllSelected),
        label: Text(isAllSelected ? 'Bỏ chọn tất cả' : 'Chọn tất cả'),
      ),
    ];
  }

  // Xây dựng AppBar phù hợp với trạng thái hiện tại
  PreferredSizeWidget _buildAppBar(bool isEditMode) {
    return AppBar(
      centerTitle: true,
      title: Text(
        isEditMode ? 'Chọn mục' : 'Quản lý Công việc',
        style: TextStyle(
          fontWeight: isEditMode ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      actions:
          isEditMode ? _buildEditAppBarActions() : _buildNormalAppBarActions(),
      leading:
          isEditMode
              ? TextButton.icon(
                onPressed: () {
                  setState(() {
                    context.read<NavigationCubit>().toggleFix();
                    context.read<TasksCubit>().clearTasksSelect();
                  });
                },
                label: const Text('Hủy'),
              )
              : null,
    );
  }

  // Xây dựng nội dung chính của màn hình
  Widget _buildContent(TasksState tasksState, bool isEditMode) {
    if (tasksState.isLoading!) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tasksState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Đã xảy ra lỗi: ${tasksState.error}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadTasks, child: const Text('Thử lại')),
          ],
        ),
      );
    }

    final tasks = tasksState.tasks;
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.task_alt, color: Colors.grey, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Chưa có nhóm công việc nào',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _showAddTaskDialog,
              icon: const Icon(Icons.add),
              label: const Text('Thêm nhóm mới'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: tasks.length,
      itemBuilder: (_, int index) {
        final taskItem = tasks[index];
        final bool isCheck = tasksState.selectedTasks[taskItem.id] ?? false;
        return GestureDetector(
          child: BuildTaskItem().buildTaskItem(
            taskItem,
            isCheck,
            isEditMode,
            (_) => _handleCheckboxChanged(taskItem.id!),
          ),
          onTap: () {
            if (!isEditMode) {
              Navigator.push(
                context,
                createRoute(TaskItemScreen(tasks: taskItem)),
              ).then((_) => _loadTasks()); // Tải lại danh sách sau khi quay lại
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = context.read<NavigationCubit>().state;
    return Scaffold(
      appBar: _buildAppBar(isEditMode),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, tasksState) => _buildContent(tasksState, isEditMode),
      ),
      floatingActionButton:
          isEditMode
              ? null
              : FloatingActionButton(
                onPressed: _showAddTaskDialog,
                child: const Icon(Icons.add),
                tooltip: 'Thêm công việc mới',
              ),
    );
  }
}
