import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/tasks/tasks_cubit.dart';
import '../../../data/models/tasks.dart';

class BuildAppBar {
  List<String> options = ['Tìm', 'Ghim', 'Giao diện', 'Đặt lời nhắc', 'Xóa'];

  Future<void> _deleteTask(BuildContext context, Tasks tasks) async {
    try {
      if (tasks.id == null) {
        print('Lỗi: ID của task là null');
        return;
      }
      await context
          .read<TasksCubit>()
          .deleteTasks(tasks.id!)
          .then((_) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Đã xóa ${tasks.title}')));
          })
          .catchError((error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Lỗi khi xóa: $error')));
          });
      print('đã xóa ${tasks.title}');
    } catch (e) {
      print('Lỗi khi xóa task: $e');
      // Hiển thị thông báo lỗi cho người dùng
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể xóa ghi chú. Lỗi: $e')));
    }
  }

  PreferredSizeWidget buildAppBar(BuildContext context, Tasks tasks) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              // Xử lý sự kiện chia sẻ
            },
            child: Icon(Icons.share_rounded),
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),

          itemBuilder: (BuildContext context) {
            return options.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
                onTap: () {
                  if (choice == 'Xóa') {
                    print('Đã chọn xóa từ onTap');
                    // Thêm một chút trì hoãn vì onTap được gọi trước khi menu đóng
                    Future.delayed(Duration(milliseconds: 200), () {
                      _deleteTask(context, tasks);
                    });
                  }
                },
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
