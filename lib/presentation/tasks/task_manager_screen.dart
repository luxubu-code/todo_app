import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/tasks/tasks_cubit.dart';
import 'package:todo/bloc/tasks/tasks_state.dart';
import 'package:todo/data/models/tasks.dart';

import 'widget/add_task_dialog.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({Key? key}) : super(key: key);

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().getTasks();
  }

  void _refreshTasks() {
    context.read<TasksCubit>().getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Công việc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => const AddTaskDialog(),
              );
              if (result == true) {
                _refreshTasks();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state.isLoading!) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Text(
                'Đã xảy ra lỗi: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final tasks = state.tasks;
          if (tasks.isEmpty) {
            return const Center(
              child: Text('Chưa có nhóm công việc nào. Hãy thêm nhóm mới!'),
            );
          } else {
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, int index) {
                final tasksItem = tasks[index];
                return _buildTasksItem(tasksItem);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildTasksItem(Tasks tasks) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tasks.title),
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      Icon(Icons.access_time),
                    ],
                  ),
                ],
              ),
              tasks.description != null
                  ? Text('Mô tả ${tasks.description}')
                  : Text('Chưa có mô tả '),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
