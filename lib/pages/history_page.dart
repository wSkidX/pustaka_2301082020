import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pengembalian_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data saat halaman dibuka
    if (mounted) {
      Future.microtask(() {
        Provider.of<PengembalianProvider>(context, listen: false).initialData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      appBar: AppBar(
        title: const Text('History Pengembalian'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<PengembalianProvider>(
        builder: (context, pengembalianProvider, child) {
          final pengembalianList = pengembalianProvider.allPengembalian;

          if (pengembalianList.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada history pengembalian',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pengembalianList.length,
            itemBuilder: (context, index) {
              final pengembalian = pengembalianList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pengembalian.judulBuku ?? 'Judul tidak tersedia',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Peminjam: ${pengembalian.namaAnggota}'),
                      Text('Tanggal Kembali: ${pengembalian.tanggalDikembalikan}'),
                      Text('Denda: Rp${pengembalian.denda}'),
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