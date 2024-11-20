import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_widget.dart';
import '../display_screen/homepage_screen.dart';
import '../information_screen/information_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  bool _isNavigating = false;

  void _navigateToScreen(Widget screen) async {
    if (_isNavigating) return;
    
    setState(() {
      _isNavigating = true;
    });

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    if (mounted) {
      setState(() {
        _isNavigating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF0C356A),
          body: Stack(
            children: [
              const Center(
                child: Text(
                  'Saved Screen',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              BottomNavWidget(
                selectedIndex: 2,
                onItemTapped: (index) {
                  if (index == 0) {
                    _navigateToScreen(const HomePageScreen());
                  } else if (index == 1) {
                    _navigateToScreen(const InformationScreen());
                  }
                },
              ),
              if (_isNavigating)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
} 