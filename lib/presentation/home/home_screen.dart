import 'package:flutter/material.dart';
import 'package:todo/presentation/home/body_home.dart';
import 'package:todo/presentation/tasks/task_manager_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({
    Key? key,
    // Thêm validator cho initialIndex
    this.initialIndex = 0,
  })  : assert(initialIndex >= 0 && initialIndex <= 3),
        // Đảm bảo initialIndex hợp lệ
        super(key: key);
  static final GlobalKey<_HomeScreenState> globalKey = GlobalKey();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index;
        _pageController.jumpToPage(index);
      });
    }
  }

  List<Widget> get _pages => [
        BodyHome(key: PageStorageKey('home')),
        TaskManagerScreen(
          key: PageStorageKey('task'),
        ),
        // RankScreen(
        //   key: PageStorageKey('showMore'),
        //   initialTabIndex: widget.rankTabIndex, // Use the passed tab index
        // ),
        // FavouritePage(key: PageStorageKey('favourite')),
        // ProfilePage(key: PageStorageKey('profile')),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Xếp hạng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Tủ truyện',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: 'Tài khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        onTap: _onTap,
      ),
    );
  }
}
