import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/navigation/navigation_cubit.dart';
import 'package:todo/bloc/tasks/tasks_cubit.dart';
import 'package:todo/presentation/home/body_home.dart';
import 'package:todo/presentation/tasks/task_manager_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({
    Key? key,
    // Thêm validator cho initialIndex
    this.initialIndex = 0,
  }) : assert(initialIndex >= 0 && initialIndex <= 3),
       // Đảm bảo initialIndex hợp lệ
       super(key: key);
  static final GlobalKey<_HomeScreenState> globalKey = GlobalKey();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  late final PageController _pageController;
  late bool fix;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex);
    fix = false;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (context.read<NavigationCubit>().state == false) {
      if (index >= 0 && index < _pages.length) {
        setState(() {
          _selectedIndex = index;
          _pageController.jumpToPage(index);
        });
      }
    } else {
      if (index >= 0 && index < _buildEditModeNavItems().length) {
        setState(() {
          _selectedIndex = index;
          switch (_selectedIndex) {
            case 0:
              context.read<TasksCubit>().confirmAndDeleteMultipleTasks(context);
              break;
            case 1:
              break;
            case 2:
              context.read<TasksCubit>().getSelectedTasks().clear();
              context.read<NavigationCubit>().toggleFix();
              break;
          }
        });
      }
    }
  }

  List<Widget> get _pages => [
    BodyHome(key: PageStorageKey('home')),
    TaskManagerScreen(key: PageStorageKey('task')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (_selectedIndex != index) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        children: _pages,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, bool>(
        builder: (BuildContext context, fixState) {
          return BottomNavigationBar(
            items:
                fixState
                    ? _buildEditModeNavItems()
                    : _buildNormalModeNavItems(),
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.pink,
            unselectedItemColor: Colors.green,
            onTap: _onTap,
          );
        },
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNormalModeNavItems() {
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
      BottomNavigationBarItem(
        icon: Icon(Icons.task),
        label: 'Quản lý công việc',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.group_work),
        label: 'Nhóm Công việc',
      ),
    ];
  }

  // Danh sách icon cho chế độ sửa
  List<BottomNavigationBarItem> _buildEditModeNavItems() {
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.delete), label: 'Xóa'),
      BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Chỉnh sửa'),
      BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Hoàn tất'),
    ];
  }
}
