import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/tasks/tasks_state.dart';
import 'package:todo/data/database/DatabaseHelper.dart';
import 'package:todo/data/models/tasks.dart';
import 'package:todo/presentation/widget/build_confirmation_dialog.dart';

class TasksCubit extends Cubit<TasksState> {
  final DatabaseHelper _databaseHelper;

  TasksCubit({required DatabaseHelper databaseHelper})
    : _databaseHelper = databaseHelper,
      super(TasksState(tasks: []));

  Future<void> getTasks() async {
    try {
      emit(state.copyWith(isLoading: true));
      final tasks = await _databaseHelper.getTasks();
      emit(state.copyWith(tasks: tasks, isLoading: false, error: null));
      print('Lấy tasks thành công');
    } catch (e) {
      print('Lỗi khi lấy tasks: $e');
      emit(
        state.copyWith(
          error: 'Lỗi getTasks: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  Future<void> addTasks(Tasks tasks) async {
    try {
      emit(state.copyWith(isLoading: true));
      final tasksId = await _databaseHelper.insertTask(tasks);
      if (tasksId > 0) {
        // Cách 1: Thêm trực tiếp vào state (nhanh nhưng có thể không đồng bộ với DB)
        final updatedTasks = [...state.tasks, tasks.copyWith(id: tasksId)];
        emit(
          state.copyWith(tasks: updatedTasks, isLoading: false, error: null),
        );

        // Cách 2: Lấy lại toàn bộ danh sách từ DB (chậm hơn nhưng đảm bảo đồng bộ)
        // await getTasks();

        print('Thêm task thành công với ID: $tasksId');
      } else {
        emit(
          state.copyWith(error: 'Thêm task không thành công', isLoading: false),
        );
      }
    } catch (e) {
      print('Lỗi khi thêm task: $e');
      emit(
        state.copyWith(
          error: 'Lỗi addTasks: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  Future<void> updateTask(Tasks task, int id) async {
    try {
      emit(state.copyWith(isLoading: true));
      final updated = await _databaseHelper.updateTask(task, id);

      if (updated > 0) {
        // Cập nhật lại danh sách tasks trong state
        final updatedTasks =
            state.tasks.map((t) {
              return t.id == id ? task.copyWith(id: id) : t;
            }).toList();

        emit(
          state.copyWith(tasks: updatedTasks, isLoading: false, error: null),
        );
        print('Cập nhật task thành công với ID: $id');
      } else {
        emit(
          state.copyWith(
            error: 'Cập nhật task không thành công',
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      print('Lỗi khi cập nhật task: $e');
      emit(
        state.copyWith(
          error: 'Lỗi updateTask: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  Future<void> deleteTasks(int id) async {
    try {
      emit(state.copyWith(isLoading: true));
      final deleted = await _databaseHelper.deleteTask(id);

      if (deleted > 0) {
        // Cập nhật lại danh sách tasks bằng cách loại bỏ task đã xóa
        final updatedTasks =
            state.tasks.where((task) => task.id != id).toList();
        emit(
          state.copyWith(tasks: updatedTasks, isLoading: false, error: null),
        );

        print('Xóa task thành công với ID: ${id}');
      } else {
        emit(
          state.copyWith(
            error: 'Task không tồn tại hoặc đã bị xóa',
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      print('Lỗi khi xóa task: $e');
      emit(
        state.copyWith(
          error: 'Lỗi deleteTasks: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  // Phương thức tìm kiếm task theo từ khóa (nếu cần)
  Future<void> searchTasks(String keyword) async {
    try {
      emit(state.copyWith(isLoading: true));
      // Giả sử bạn đã thêm phương thức searchTasks trong DatabaseHelper
      // final tasks = await _databaseHelper.searchTasks(keyword);

      // Hoặc lọc từ danh sách tasks hiện có (đơn giản hơn)
      final filteredTasks =
          state.tasks
              .where(
                (task) =>
                    task.title.toLowerCase().contains(keyword.toLowerCase()) ||
                    (task.description?.toLowerCase() ?? '').contains(
                      keyword.toLowerCase(),
                    ),
              )
              .toList();

      emit(state.copyWith(tasks: filteredTasks, isLoading: false, error: null));

      print('Tìm kiếm tasks thành công với từ khóa: $keyword');
    } catch (e) {
      print('Lỗi khi tìm kiếm tasks: $e');
      emit(
        state.copyWith(
          error: 'Lỗi searchTasks: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  Future<void> confirmAndDeleteTasks(BuildContext context, int id) async {
    try {
      bool confirmed = await BuildConfirmationDialog.showComfirmDialog(
        context,
        'Bạn có muốn xóa tasks này không',
        'Xác nhận Xóa',
      );
      if (confirmed) {
        await deleteTasks(id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa task thành công')),
          );
        }
      }
    } catch (e) {
      print('lỗi khi comfirmAndDeleteTasks : $e');
      throw Expando('lỗi khi comfirmAndDeleteTasks : $e');
    }
  }

  Future<void> confirmAndDeleteMultipleTasks(BuildContext context) async {
    final List<int> listId =
        state.selectedTasks.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();
    try {
      if (listId.isEmpty) return;
      bool confirmed = await BuildConfirmationDialog.showComfirmDialog(
        context,
        'Bạn có muốn xóa $listId tasks này không',
        'Xác nhận Xóa',
      );
      if (confirmed) {
        for (final id in listId) {
          await deleteTasks(id);
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa task thành công')),
          );
        }
      }
    } catch (e) {
      print('lỗi khi comfirmAndDeleteTasks : $e');
      throw Expando('lỗi khi comfirmAndDeleteTasks : $e');
    }
  }

  void selectTasks(int id) {
    final newState = state.toggleTaskSelection(id);
    emit(newState);
    _updateAllSelectedStatus();
  }

  void _updateAllSelectedStatus() {
    if (state.tasks.isEmpty) {
      emit(state.copyWith(isAllSelected: false));
      return;
    }
    bool allSelect = state.tasks.every(
      (task) => state.selectedTasks[task.id] == true,
    );
    if (state.isAllSelected != allSelect) {
      emit(state.copyWith(isAllSelected: allSelect));
    }
  }

  void clearTasksSelect() {
    emit(state.copyWith(selectedTasks: <int, bool>{}, isAllSelected: false));
    print('Đã xóa tất cả trạng thái đã chọn');
  }

  bool get isAllSelected => state.isAllSelected;

  void selectAllTask(bool isSelected) {
    if (state.tasks.isEmpty) {
      emit(state.copyWith(isAllSelected: false));
      print('selectAllTask không có task để chọn');
      return;
    }
    final newSelectedTasks = Map<int, bool>.fromIterable(
      state.tasks,
      key: (task) => task.id,
      value: (task) => isSelected,
    );
    emit(
      state.copyWith(
        selectedTasks: newSelectedTasks,
        isAllSelected: isSelected,
      ),
    );
  }

  List<Tasks> getSelectedTasks() {
    final selectedIds =
        state.selectedTasks.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();

    return state.tasks
        .where((task) => task.id != null && selectedIds.contains(task.id))
        .toList();
  }
}
