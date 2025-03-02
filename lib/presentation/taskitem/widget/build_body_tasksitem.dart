import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/tasks.dart';

class BuildBodyTasksitem {
  Widget buildBodyTasksItem(
    TextEditingController titleController,
    TextEditingController contentController,
    Tasks tasks,
    Function(String) updateTitle,
    Function(String) updateDescription,
  ) {
    final timeFormatter = DateFormat('HH:mm dd/M/yyyy');
    final formattedTime = timeFormatter.format(tasks.created_at!);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                // Hiển thị thời gian và ngày tháng
                Text(
                  formattedTime,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Text(
                  ' | ',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),

                // Hiển thị trạng thái
                Text(
                  'trạng thái : ${tasks.status}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          // Trường nhập tiêu đề
          TextField(
            controller: titleController,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Tiêu đề',
            ),
            onChanged: updateTitle,
          ),
          const SizedBox(height: 16),
          // Trường nhập nội dung
          Expanded(
            child: TextField(
              controller: contentController,
              style: const TextStyle(fontSize: 16),
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Nội dung ghi chú...',
              ),
              onChanged: updateDescription,
            ),
          ),
        ],
      ),
    );
  }
}
