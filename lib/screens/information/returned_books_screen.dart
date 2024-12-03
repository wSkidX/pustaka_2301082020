import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/pengembalian_provider.dart';
import '../../providers/anggota_provider.dart';

class ReturnedBooksScreen extends StatefulWidget {
  const ReturnedBooksScreen({super.key});

  @override
  State<ReturnedBooksScreen> createState() => _ReturnedBooksScreenState();
}

class _ReturnedBooksScreenState extends State<ReturnedBooksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AnggotaProvider>().userId;
      if (userId != null) {
        context.read<PengembalianProvider>().getPengembalian(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buku yang Sudah Dikembalikan'),
        backgroundColor: const Color(0xFF0C356A),
        foregroundColor: Colors.white,
      ),
      body: Consumer<PengembalianProvider>(
        builder: (context, pengembalianProvider, child) {
          if (pengembalianProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pengembalianProvider.error != null) {
            return Center(child: Text(pengembalianProvider.error!));
          }

          final pengembalian = pengembalianProvider.pengembalian;
          
          if (pengembalian.isEmpty) {
            return const Center(
              child: Text('Tidak ada riwayat pengembalian buku'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pengembalian.length,
            itemBuilder: (context, index) {
              final kembali = pengembalian[index];
              
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Judul Buku: ${kembali.judulBuku}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tanggal Dikembalikan: ${DateFormat('dd/MM/yyyy').format(kembali.tanggalDikembalikan!)}',
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