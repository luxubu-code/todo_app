import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<bool> {
  NavigationCubit() : super(false);

  void toggleFix() {
    emit(!state);
  }
}
