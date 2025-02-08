import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  double _x = 0;
  double _y = 0;

  // Biến cờ để đảm bảo chỉ khởi tạo một lần.
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Khởi tạo _x và _y dựa trên MediaQuery khi context đã sẵn sàng.
    if (!_initialized) {
      final size = MediaQuery.of(context).size;
      // Ví dụ: đặt _x bằng 20% chiều rộng màn hình
      _x = size.width * 0.85;
      // Ví dụ: đặt _y bằng chiều cao màn hình (có thể điều chỉnh sao cho phù hợp với mong muốn)
      _y = size.height * 0.6;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onPanUpdate: (detail) {
          setState(() {
            _x += detail.delta.dx;
            _y += detail.delta.dy;
          });
          print("location $_x $_y");
          final size = MediaQuery.of(context).size;
          _x = _x.clamp(0, size.width - 45);
          _y = _y.clamp(0, size.height - 45);
        },
        child: Container(
          height: 45,
          width: 45,
          decoration:
              ShapeDecoration(shape: CircleBorder(), color: Colors.grey[300]),
          child: IconButton(
            onPressed: () {
              // Xử lý khi nhấn nút
            },
            icon: Icon(Icons.edit),
          ),
        ),
      ),
    );
  }
}
