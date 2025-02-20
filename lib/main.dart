import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/tasks/tasks_cubit.dart';
import 'package:todo/bloc/theme/theme_state.dart';
import 'package:todo/presentation/home/home_screen.dart';

import 'bloc/category/categories_cubit.dart';
import 'bloc/theme/theme_cubit.dart';
import 'data/database/DatabaseHelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(
          create:
              (context) =>
                  CategoriesCubit(databaseHelper: DatabaseHelper.instance),
        ),
        BlocProvider(
          create:
              (context) => TasksCubit(databaseHelper: DatabaseHelper.instance),
        ),
        // BlocProvider(create: (context) => TasksBloc()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: context.read<ThemeCubit>().theme,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
