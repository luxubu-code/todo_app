import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/theme/theme_state.dart';
import 'package:todo/config/theme/app_theme.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(isDarkMode: false));

  void toggleTheme() {
    return emit(
      state.copyWith(isDarkMode: !state.isDarkMode),
    );
  }

  void setDarkMode(bool isDark) {
    emit(state.copyWith(isDarkMode: isDark));
  }

  ThemeData get theme =>
      state.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
}
