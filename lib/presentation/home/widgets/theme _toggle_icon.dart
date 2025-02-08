// Widget riêng để xử lý animation cho icon chuyển đổi theme
import 'package:flutter/material.dart';

// Đây là thời gian chuyển đổi lý tưởng cho animation - đủ dài để nhìn thấy hiệu ứng
// nhưng đủ ngắn để không làm gián đoạn trải nghiệm người dùng
const Duration animationDuration = Duration(milliseconds: 300);
// Curves.easeInOut tạo ra chuyển động tự nhiên, mượt mà ở cả điểm bắt đầu và kết thúc
const Curve animationCurve = Curves.easeInOut;

class ThemeToggleIcon extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onPressed;

  const ThemeToggleIcon({
    Key? key,
    required this.isDarkMode,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AnimatedContainer sẽ xử lý việc chuyển đổi màu sắc một cách mượt mà
    return AnimatedContainer(
      duration: animationDuration,
      curve: animationCurve,
      decoration: ShapeDecoration(
        color: isDarkMode ? Colors.yellow[300] : Colors.grey[900],
        shape: CircleBorder(),
      ),
      child: IconButton(
        onPressed: onPressed,
        // TweenAnimationBuilder tạo hiệu ứng xoay mượt mà khi chuyển đổi icon
        icon: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: isDarkMode ? 1.0 : 0.0),
          duration: animationDuration,
          curve: animationCurve,
          builder: (context, value, child) {
            return Transform.rotate(
              angle: value * 2 * 3.14159, // Xoay một vòng hoàn chỉnh
              child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: isDarkMode ? Colors.orange[900] : Colors.yellow[200]),
            );
          },
        ),
      ),
    );
  }
}
