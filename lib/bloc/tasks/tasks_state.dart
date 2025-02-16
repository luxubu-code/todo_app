import 'package:equatable/equatable.dart';

import '../../data/models/tasks.dart';

class TasksState extends Equatable{
  final List<Tasks> tasks;
  final bool? isLoading;
  final String? error;

 const  TasksState({
   this.tasks=const[],this.isLoading = false,this.error,
});
  TasksState copyWith({
    List<Tasks>? tasks,
     bool? isLoading,
     String? error,
}){
    return TasksState(
      tasks: tasks?? this.tasks,
      isLoading:isLoading??this.isLoading,
      error:error??this.error,
    );
  }
  @override
  List<Object?> get props => [tasks,isLoading,error];

}