import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/presentation/home/widgets/add_button.dart';

import '../../bloc/theme/theme_cubit.dart';
import '../../bloc/theme/theme_state.dart';

class BodyHome extends StatefulWidget {
  const BodyHome({super.key});

  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(),
            AddButton(),
          ],
        );
      },
    );
  }
}
