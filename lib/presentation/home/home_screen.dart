import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/theme/theme_cubit.dart';
import 'package:todo/bloc/theme/theme_state.dart';
import 'package:todo/presentation/home/body_home.dart';
import 'package:todo/presentation/home/widgets/theme%20_toggle_icon.dart';
import 'package:todo/presentation/search/search_screen.dart';

import '../../config/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<ThemeCubit, ThemeState>(
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
                        style: TextStyle(
                            fontSize: 12, overflow: TextOverflow.visible),
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
        ),
      ),
      body: BodyHome(),
    );
  }
}
