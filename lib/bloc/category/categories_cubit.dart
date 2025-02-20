import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/category/categories_state.dart';

import '../../data/database/DatabaseHelper.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final DatabaseHelper _databaseHelper;

  CategoriesCubit({required DatabaseHelper databaseHelper})
    : _databaseHelper = databaseHelper,
      super(const CategoriesState());

  Future<void> addCategories(String title, int color) async {
    try {
      emit(state.copyWith(isLoading: true));
      final categories = {'title': title, 'color': color};
      await _databaseHelper.insertCategory(categories);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> getCategories() async {
    try {
      emit(state.copyWith(isLoading: true));
      final categories = await _databaseHelper.getCategories();
      emit(state.copyWith(categories: categories, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
