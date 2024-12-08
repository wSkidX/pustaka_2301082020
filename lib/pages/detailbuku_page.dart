import 'package:flutter/material.dart';
import '../models/buku.dart';
import 'pinjam_buku_page.dart';

class DetailBukuPage extends StatelessWidget {
  final Buku buku;

  const DetailBukuPage({super.key, required this.buku});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      appBar: AppBar(
        title: const Text('Detail Buku'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: buku.cover.isNotEmpty
                    ? Image.network(
                        buku.cover,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Book Details
            Text(
              buku.judul,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pengarang: ${buku.pengarang}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Penerbit: ${buku.penerbit}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tahun Terbit: ${buku.tahunTerbit}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kategori: ${buku.kategori}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            
            // Pinjam Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PinjamBukuPage(buku: buku),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pinjam Buku',
                  style: TextStyle(
                    color: Color(0xFF0C356A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
