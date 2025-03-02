import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/tasks.dart';
import '../task_manager_screen.dart';

// các tasks con trong tasks manager screen
class BuildTaskItem {
  Widget buildTaskItem(
    ViewMode viewMode,
    Tasks task,
    bool checked,
    bool fix,
    void Function(bool?) onCheckboxChanged,
  ) {
    final timeFormatter = DateFormat('HH:mm dd/M/yyyy');
    final formattedTime = timeFormatter.format(task.created_at!);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  task.title,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        if (fix)
                          Checkbox(
                            value: checked,
                            onChanged: onCheckboxChanged,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Overlay cho task đã hết hạn
        ],
      ),
    );
  }
}
