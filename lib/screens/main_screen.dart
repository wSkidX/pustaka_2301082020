import 'package:flutter/material.dart';
import 'display_screen/homepage_screen.dart';
import 'information_screen/information_screen.dart';
import 'saved_screen/saved_screen.dart';
import 'profile/profile_screen.dart';
import '../widgets/bottom_nav_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePageScreen(),
    const InformationScreen(),
    const SavedScreen(),
    const ProfileScreen(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: BottomNavWidget(
          currentIndex: _currentIndex,
          onTap: _onNavTapped,
        ),
      ),
    );
  }
} 