import 'package:flutter/material.dart';

class BuildSelectDateTime extends StatefulWidget {
  final Function(int)? onTabChanged; // Callback khi tab thay đổi

  const BuildSelectDateTime({super.key, this.onTabChanged});

  @override
  State<BuildSelectDateTime> createState() => _BuildSelectDateTimeState();
}

class _BuildSelectDateTimeState extends State<BuildSelectDateTime>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  DateTime? _selectedDateTime;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        widget.onTabChanged?.call(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const <Widget>[Tab(text: 'Giờ'), Tab(text: 'Ngày')],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  Center(
                    child: Text(
                      "Nội dung tab 1",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Nội dung tab 2",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
