import 'package:flutter/material.dart';
import 'package:flutter_reminder_payment/screens/auth_screen.dart';
import '../screens/homepage_screen.dart';
import '../screens/budget_popupdialog.dart';
import '../widgets/drawer.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': HomePage(),
        'title': 'Payment App Reminder',
      },
      {
        'page': AuthScreen(),
        'title': 'History',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).backgroundColor,
        selectedItemColor: Theme.of(context).highlightColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'history'),
        ],
      ),
    );
  }
}
