import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/anggota_provider.dart';
import 'providers/buku_provider.dart';
import 'providers/peminjaman_provider.dart';
import 'providers/pengembalian_provider.dart';
import 'pages/login_page.dart';
import 'main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnggotaProvider()),
        ChangeNotifierProvider(create: (_) => BukuProvider()),
        ChangeNotifierProvider(create: (_) => PeminjamanProvider()),
        ChangeNotifierProvider(create: (_) => PengembalianProvider()),
      ],
      child: MaterialApp(
        title: 'Pustaka Digital',
        theme: AppTheme.theme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/main': (context) => const MainScreen(),
        },
      ),
    );
  }
}
