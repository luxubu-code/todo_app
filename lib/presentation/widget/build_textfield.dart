import 'package:flutter/material.dart';

class BuildTextField {
  /// Phương thức buildTextField tạo ra một TextFormField với các cài đặt mặc định
  /// [controller]: Quản lý dữ liệu nhập vào của TextFormField
  /// [hint]: Văn bản gợi ý hiển thị khi trường trống
  /// [icon]: Biểu tượng hiển thị ở bên trái của TextFormField
  /// [maxLines]: Số dòng tối đa hiển thị (mặc định là 1)
  Widget buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextFormField(
      // Liên kết controller với TextFormField để theo dõi và quản lý nội dung nhập vào
      controller: controller,
      // Đặt kiểu chữ cho nội dung nhập (màu trắng)
      style: const TextStyle(fontSize: 16),
      // Xác định số dòng tối đa của TextFormField
      maxLines: maxLines,
      // Cấu hình giao diện của TextFormField thông qua InputDecoration
      decoration: InputDecoration(
        // Văn bản gợi ý (placeholder) hiển thị khi không có dữ liệu
        hintText: hint,
        // Kiểu chữ của văn bản gợi ý (màu trắng nhạt)
        // hintStyle: const TextStyle(color: Colors.white70),
        // Biểu tượng hiển thị ở bên trái trường nhập với màu trắng nhạt
        // prefixIcon: Icon(icon, color: Colors.white70),
        // Kích hoạt nền cho TextFormField
        filled: true,
        // Màu nền với độ mờ 10% (sử dụng withOpacity thay vì withValues)
        // fillColor: Colors.white.withOpacity(0.1),
        // Định dạng viền của TextFormField:
        // Sử dụng OutlineInputBorder với góc bo tròn và không hiển thị đường viền
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      // Hàm validator kiểm tra dữ liệu nhập vào; nếu trống, trả về thông báo lỗi
      validator:
          (value) => (value?.isEmpty ?? true) ? "Vui lòng nhập $hint" : null,
    );
  }
}
