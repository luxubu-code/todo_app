// Hàm helper tạo Route với hiệu ứng chuyển trang (animation)
// Sử dụng PageRouteBuilder để tùy chỉnh hiệu ứng chuyển trang
import 'package:flutter/material.dart';

Route createRoute(Widget page) {
  return PageRouteBuilder(
    // pageBuilder: Xây dựng trang mới (widget) khi điều hướng
    // Các tham số:
    // - context: BuildContext của widget hiện tại
    // - animation: Animation controller cho hiệu ứng chuyển trang
    // - secondaryAnimation: Animation controller cho các animation phụ (thường dùng cho các hiệu ứng khác)
    pageBuilder: (context, animation, secondaryAnimation) => page,

    // transitionDuration: Thời gian cho hiệu ứng chuyển trang khi push route (500 milliseconds)
    transitionDuration: const Duration(milliseconds: 500),

    // reverseTransitionDuration: Thời gian cho hiệu ứng chuyển trang khi pop route (500 milliseconds)
    reverseTransitionDuration: const Duration(milliseconds: 500),

    // transitionsBuilder: Xây dựng hiệu ứng chuyển trang sử dụng các animation đã cung cấp
    // Tham số:
    // - context: BuildContext của widget hiện tại
    // - animation: Animation controller chính (điều khiển hiệu ứng chuyển trang vào)
    // - secondaryAnimation: Animation controller phụ (điều khiển hiệu ứng chuyển trang ra)
    // - child: Widget trang mới được xây dựng bởi pageBuilder
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Định nghĩa điểm bắt đầu của hiệu ứng slide: ngoài màn hình bên phải (x = 1.0, y = 0.0)
      var begin = const Offset(1.0, 0.0);
      // Điểm kết thúc của hiệu ứng slide: vị trí gốc (trong màn hình, Offset.zero)
      var end = Offset.zero;
      // Xác định đường cong (curve) cho hiệu ứng animation, giúp hiệu ứng mượt mà hơn
      var curve = Curves.easeInOut;

      // Tạo Tween để xác định quá trình chuyển động của animation từ điểm bắt đầu đến điểm kết thúc
      // Sau đó chain với CurveTween để áp dụng đường cong cho animation
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      // SlideTransition: Widget sử dụng animation để dịch chuyển (slide) widget con (child)
      // position: Nhận giá trị của animation đã được liên kết (drive) với tween, tạo ra hiệu ứng dịch chuyển từ begin đến end
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

//Hiệu ứng fade
Route createFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
  );
}
