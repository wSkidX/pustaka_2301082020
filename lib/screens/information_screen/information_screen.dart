import 'package:flutter/material.dart';
class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C356A),
        title: const Text(
          'Peminjaman Aktif',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: const SafeArea(
        child: Center(
          child: Text(
            'Tidak ada peminjaman aktif',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
} 