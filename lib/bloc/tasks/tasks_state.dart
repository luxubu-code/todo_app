import 'package:equatable/equatable.dart';

import '../../data/models/tasks.dart';

class TasksState extends Equatable {
  final List<Tasks> tasks;
  final bool? isLoading;
  final String? error;
  final Map<int, bool> selectedTasks;
  final bool isAllSelected;

  TasksState({
    required this.tasks,
    this.isLoading = false,
    this.error,
    Map<int, bool>? selectedTasks,
    bool? isAllSelected,
  }) : selectedTasks = selectedTasks ?? {},
       isAllSelected = isAllSelected ?? false;

  bool get areAllTasksSelected {
    if (tasks.isEmpty) return false;
    return tasks.every((task) => selectedTasks[task.id] == true);
  }

  TasksState copyWith({
    List<Tasks>? tasks,
    bool? isLoading,
    String? error,
    Map<int, bool>? selectedTasks,
    bool? isAllSelected,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedTasks: selectedTasks ?? this.selectedTasks,
      isAllSelected: isAllSelected ?? this.isAllSelected,
    );
  }

  TasksState toggleTaskSelection(int id) {
    final newSelectedTasks = Map<int, bool>.from(selectedTasks);
    newSelectedTasks[id] = !(selectedTasks[id] ?? false);

    // Kiểm tra xem sau khi toggle, tất cả tasks có được chọn không
    bool allSelected =
        tasks.isNotEmpty &&
        tasks.every(
          (task) =>
              task.id == id
                  ? newSelectedTasks[id]!
                  : (selectedTasks[task.id] ?? false),
        );

    return copyWith(
      selectedTasks: newSelectedTasks,
      isAllSelected: allSelected,
    );
  }

  @override
  List<Object?> get props => [
    tasks,
    isLoading,
    error,
    selectedTasks,
    isAllSelected,
  ];
}
