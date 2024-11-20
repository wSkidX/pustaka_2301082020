import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_widget.dart';
import '../display_screen/homepage_screen.dart';
import '../saved_screen/saved_screen.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
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
                  'Information Screen',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              BottomNavWidget(
                selectedIndex: 1,
                onItemTapped: (index) {
                  if (index == 0) {
                    _navigateToScreen(const HomePageScreen());
                  } else if (index == 2) {
                    _navigateToScreen(const SavedScreen());
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