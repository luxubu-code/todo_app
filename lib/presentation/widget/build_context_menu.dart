import 'package:flutter/material.dart';

class BuildContextMenu {
  final List<String> options;
  final Function(String) onSelect;
  final double horizontalPadding = 20.0; // Khoảng cách lùi vào từ mép phải

  BuildContextMenu({required this.options, required this.onSelect});

  Future<void> showContextMenu(BuildContext context, RenderBox button) async {
    final buttonSize = button.size;

    // Lấy kích thước màn hình thông qua overlay
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final screenSize = overlay.size;

    // Tính toán vị trí cho menu
    // Đặt menu bên dưới nút bấm
    final double estimatedMenuWidth = 200.0;

    double dy = screenSize.height - screenSize.height * 0.9;

    // Tính toán vị trí x để menu lùi vào 20dp từ mép phải
    // Giả định menu có chiều rộng khoảng 200dp
    double dx = screenSize.width - estimatedMenuWidth - horizontalPadding;

    final RelativeRect positionRect = RelativeRect.fromRect(
      Rect.fromPoints(Offset(dx, dy), Offset(dx + estimatedMenuWidth, dy + 1)),
      Offset.zero & screenSize,
    );

    final String? selectedValue = await showMenu<String>(
      context: context,
      items: _buildMenuItems(),
      position: positionRect,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
    );

    if (selectedValue != null) {
      onSelect(selectedValue);
    }
  }

  List<PopupMenuEntry<String>> _buildMenuItems() {
    return options.map((option) {
      return PopupMenuItem<String>(
        value: option,
        height: 48,
        child: Text(option, style: const TextStyle(fontSize: 14)),
      );
    }).toList();
  }
}
