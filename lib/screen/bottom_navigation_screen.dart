import 'package:flutter/material.dart';
import 'package:shipper/screen/bookmark_screen.dart';
import 'package:shipper/screen/home_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var screens = [
      const HomeScreen(),
      const BookMarkScreen(),
    ];
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.green,
        elevation: 0,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        mouseCursor: MouseCursor.uncontrolled,
        unselectedFontSize: 12,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Trang chủ')),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), title: Text('Đơn đã lưu')),
          // items
        ],
      ),
    );
  }
}
