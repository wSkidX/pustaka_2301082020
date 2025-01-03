import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anggota_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final anggota = Provider.of<AnggotaProvider>(context).currentAnggota;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.library_books, size: 100, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              'Selamat datang, ${anggota?.nama ?? ""}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Silakan gunakan menu navigasi di bawah untuk mengakses fitur-fitur aplikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
