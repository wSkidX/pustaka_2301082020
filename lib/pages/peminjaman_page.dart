import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/peminjaman_provider.dart';
import '../providers/pengembalian_provider.dart';

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      appBar: AppBar(
        title: const Text('Daftar Peminjaman'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<PeminjamanProvider>(
        builder: (context, peminjamanProvider, child) {
          if (peminjamanProvider.allPeminjaman.isEmpty) {
            peminjamanProvider.initialData();
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: peminjamanProvider.allPeminjaman.length,
            itemBuilder: (context, index) {
              final peminjaman = peminjamanProvider.allPeminjaman[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cover Image
                      Container(
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(peminjaman.cover ?? ''),
                            fit: BoxFit.cover,
                            onError: (_, __) => const Icon(Icons.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Book Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              peminjaman.judulBuku ?? 'Judul tidak tersedia',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Peminjam: ${peminjaman.namaAnggota}',
                              style: const TextStyle(color: Colors.black87),
                            ),
                            Text(
                              'Tanggal Pinjam: ${peminjaman.tanggalPinjam}',
                              style: const TextStyle(color: Colors.black87),
                            ),
                            Text(
                              'Tanggal Kembali: ${peminjaman.tanggalKembali}',
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0C356A),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              onPressed: () async {
                                // Tampilkan dialog konfirmasi
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        const Text('Konfirmasi Pengembalian'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin mengembalikan buku ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Ya'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true && context.mounted) {
                                  try {
                                    final pengembalianProvider =
                                        Provider.of<PengembalianProvider>(
                                            context,
                                            listen: false);

                                    final result = await pengembalianProvider
                                        .addPengembalian(
                                      DateTime.now()
                                          .toIso8601String()
                                          .split('T')[0],
                                      peminjaman.id,
                                    );

                                    if (result != null &&
                                        result['success'] &&
                                        context.mounted) {
                                      // Refresh data peminjaman
                                      await peminjamanProvider.initialData();

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Buku berhasil dikembalikan. ${result['terlambat'] > 0 ? 'Terlambat ${result['terlambat']} hari. Denda: Rp${result['denda']}' : 'Tepat waktu.'}'),
                                            backgroundColor:
                                                result['terlambat'] > 0
                                                    ? Colors.red
                                                    : Colors.green,
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Terjadi kesalahan saat mengembalikan buku'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              child: const Text(
                                'Kembalikan Buku',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
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
