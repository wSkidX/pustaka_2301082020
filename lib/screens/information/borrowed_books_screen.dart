import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/peminjaman_provider.dart';
import '../../providers/anggota_provider.dart';
import '../book/return_book_screen.dart';

class BorrowedBooksScreen extends StatefulWidget {
  const BorrowedBooksScreen({super.key});

  @override
  State<BorrowedBooksScreen> createState() => _BorrowedBooksScreenState();
}

class _BorrowedBooksScreenState extends State<BorrowedBooksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AnggotaProvider>().userId;
      if (userId != null) {
        context.read<PeminjamanProvider>().getPeminjaman(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buku yang Dipinjam'),
        backgroundColor: const Color(0xFF0C356A),
        foregroundColor: Colors.white,
      ),
      body: Consumer<PeminjamanProvider>(
        builder: (context, peminjamanProvider, child) {
          if (peminjamanProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (peminjamanProvider.error != null) {
            return Center(child: Text(peminjamanProvider.error!));
          }

          final peminjaman = peminjamanProvider.peminjaman;
          
          if (peminjaman.isEmpty) {
            return const Center(
              child: Text('Tidak ada buku yang sedang dipinjam'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: peminjaman.length,
            itemBuilder: (context, index) {
              final pinjam = peminjaman[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Judul Buku: ${pinjam.judulBuku}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tanggal Pinjam: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(pinjam.tanggalPinjam))}',
                      ),
                      Text(
                        'Tanggal Kembali: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(pinjam.tanggalKembali))}',
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReturnBookForm(
                                  peminjaman: pinjam,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0C356A),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Kembalikan Buku',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 