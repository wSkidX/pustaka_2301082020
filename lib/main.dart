import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/display_screen/homepage_screen.dart';
import 'screens/information_screen/information_screen.dart';
import 'screens/saved_screen/saved_screen.dart';
//import 'screens/profile_screen/profile_screen.dart';
import 'screens/auth_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MainApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pustaka App',
      theme: ThemeData(
        primaryColor: const Color(0xFF0C356A),
        fontFamily: 'Outfit',
      ),
      initialRoute: isLoggedIn ? '/main' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePageScreen(),
    const InformationScreen(),
    const SavedScreen(),
    //const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            _screens[_selectedIndex],
            Positioned(
              left: 60,
              right: 60,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Home Button
                    _buildNavItem(
                      icon: Icons.home_outlined,
                      label: _selectedIndex == 0 ? 'Home' : null,
                      isSelected: _selectedIndex == 0,
                      onTap: () => _onItemTapped(0),
                    ),
                    // Information Button
                    _buildNavItem(
                      icon: Icons.info_outline,
                      isSelected: _selectedIndex == 1,
                      onTap: () => _onItemTapped(1),
                    ),
                    // Saved Button
                    _buildNavItem(
                      icon: Icons.bookmark_border,
                      isSelected: _selectedIndex == 2,
                      onTap: () => _onItemTapped(2),
                    ),
                    // Profile Button
                    _buildNavItem(
                      icon: Icons.person_outline,
                      isSelected: _selectedIndex == 3,
                      onTap: () => _onItemTapped(3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    String? label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              size: 24,
            ),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
