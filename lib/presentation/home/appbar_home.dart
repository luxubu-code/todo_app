import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/presentation/home/widgets/theme%20_toggle_icon.dart';

import '../../bloc/theme/theme_cubit.dart';
import '../../bloc/theme/theme_state.dart';
import '../../config/routes/app_routes.dart';
import '../search/search_screen.dart';

class AppbarHome extends StatefulWidget {
  const AppbarHome({super.key});

  @override
  State<AppbarHome> createState() => _AppbarHomeState();
}

class _AppbarHomeState extends State<AppbarHome> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ThemeToggleIcon(
              isDarkMode: state.isDarkMode,
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
          ),
          title: Row(
            children: [
              const CircleAvatar(),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Họ và Tên',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Linhpro631@gmail.com',
                    style:
                        TextStyle(fontSize: 12, overflow: TextOverflow.visible),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(createRoute(SearchScreen()));
                print('ấn nút');
              },
              icon: Icon(
                Icons.search,
              ),
            ),
          ],
        );
      },
    );
  }
}
