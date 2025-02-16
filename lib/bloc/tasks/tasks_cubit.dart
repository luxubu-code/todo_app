import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/tasks/tasks_state.dart';
import 'package:todo/data/database/DatabaseHelper.dart';

class TasksCubit extends Cubit<TasksState> {
  final DatabaseHelper _databaseHelper;

  TasksCubit({required DatabaseHelper databaseHelper})
    : _databaseHelper = databaseHelper,
      super(const TasksState());

  Future<void> getTasks() async {
    emit(state.copyWith(isLoading: false));

    emit(state.copyWith(isLoading: true));
  }
}
