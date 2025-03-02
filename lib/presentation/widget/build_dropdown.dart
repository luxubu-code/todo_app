import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String? hintText;
  final List<String>? items;
  final String? initialValue;
  final Function(String?)? onValueChanged;

  const CustomDropdown({
    Key? key,
    this.hintText,
    required this.items,
    this.initialValue,
    this.onValueChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  // Biến để lưu trữ giá trị được chọn
  String? _selected;

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị ban đầu nếu có
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.flag, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: Colors.grey[900],
      value: _selected,
      items:
          widget.items!
              .map(
                (String value) => DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
      onChanged: (newValue) {
        setState(() {
          _selected = newValue;
        });
        // Gọi callback function nếu được cung cấp
        if (widget.onValueChanged != null) {
          widget.onValueChanged!(newValue);
        }
      },
    );
  }
}
