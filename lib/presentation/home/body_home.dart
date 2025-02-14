import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/presentation/home/widgets/add_button.dart';

import '../../bloc/theme/theme_cubit.dart';
import '../../bloc/theme/theme_state.dart';
import 'appbar_home.dart';

class BodyHome extends StatefulWidget {
  const BodyHome({super.key});

  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool hasTask = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarHome(),
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: DateTime.utc(2020, 1, 1),
                      // Ngày bắt đầu hiển thị
                      lastDay: DateTime.utc(2030, 12, 31),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: hasTask
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        children: [
                          Text(
                            hasTask
                                ? 'Việc làm đã lên lịch'
                                : 'Chưa thêm việc cần làm',
                            style: TextStyle(fontSize: 16),
                          ),
                          if (hasTask)
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.format_line_spacing),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              AddButton(),
            ],
          );
        },
      ),
    );
  }
}
