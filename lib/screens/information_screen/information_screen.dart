import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/anggota_provider.dart';
import '../information/borrowed_books_screen.dart';
import '../information/returned_books_screen.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final anggota = context.read<AnggotaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi'),
        backgroundColor: const Color(0xFF0C356A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Info Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang, ${anggota.userName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('NIM: ${anggota.nim ?? "-"}'),
                    Text('Email: ${anggota.email}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Menu Buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BorrowedBooksScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C356A),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Buku yang Dipinjam',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReturnedBooksScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C356A),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Buku yang Sudah Dikembalikan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}