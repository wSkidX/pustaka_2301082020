import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/anggota_provider.dart';
import 'screens/anggota_screen/login_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnggotaProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pustaka App',
      theme: ThemeData(
        primaryColor: const Color(0xFF0C356A),
        fontFamily: 'Outfit',
      ),
      home: Consumer<AnggotaProvider>(
        builder: (context, anggota, _) {
          return anggota.isLoggedIn ? const MainScreen() : const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
