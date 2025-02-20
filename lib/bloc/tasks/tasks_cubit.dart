import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/tasks/tasks_state.dart';
import 'package:todo/data/database/DatabaseHelper.dart';
import 'package:todo/data/models/tasks.dart';

class TasksCubit extends Cubit<TasksState> {
  final DatabaseHelper _databaseHelper;

  TasksCubit({required DatabaseHelper databaseHelper})
    : _databaseHelper = databaseHelper,
      super(const TasksState());

  Future<void> getTasks() async {
    try {
      emit(state.copyWith(isLoading: true));
      final tasks = await _databaseHelper.getTasks();
      emit(state.copyWith(tasks: tasks, isLoading: false, error: null));
      print('lấy tasks thành công');
    } catch (e) {
      emit(
        state.copyWith(
          error: 'lỗi getTasks : ${e.toString()}',
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
        final updateTasks = [...state.tasks, tasks.copyWith(id: tasksId)];
        emit(state.copyWith(tasks: updateTasks, isLoading: false, error: null));
      }
      print('thêm tasks thành công');
    } catch (e) {
      emit(
        state.copyWith(
          error: 'lỗi addTasks : ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }
}
