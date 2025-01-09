import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/peminjaman_provider.dart';
import '../providers/pengembalian_provider.dart';
import '../providers/anggota_provider.dart';
import '../models/peminjaman.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  @override
  void initState() {
    super.initState();
    // Inisialisasi data peminjaman
    Future.microtask(() =>
        Provider.of<PeminjamanProvider>(context, listen: false).initialData());
  }

  @override
  Widget build(BuildContext context) {
    final peminjamanProvider = Provider.of<PeminjamanProvider>(context);
    final anggotaProvider = Provider.of<AnggotaProvider>(context);
    final currentAnggota = anggotaProvider.currentAnggota;

    if (currentAnggota == null) {
      return const Center(child: Text('Silakan login terlebih dahulu'));
    }

    // Filter peminjaman yang masih aktif (status = 'Dipinjam')
    final peminjaman = peminjamanProvider
        .getPeminjamanByAnggota(currentAnggota.id)
        .where((pinjam) => pinjam.status == 'Dipinjam')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      appBar: AppBar(
        title: const Text('Peminjaman Saya'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: peminjaman.length,
        itemBuilder: (context, index) {
          final pinjam = peminjaman[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pinjam.judulBuku ?? 'Judul tidak tersedia',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Tanggal Pinjam: ${pinjam.tanggalPinjam}'),
                  Text('Lama Pinjam: ${pinjam.hariPinjam} hari'),
                  Text('Status: ${pinjam.status}'),
                  if (pinjam.status == 'Dipinjam') ...[
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _showKembalikanDialog(context, pinjam),
                        child: const Text(
                          'Kembalikan Buku',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showKembalikanDialog(
      BuildContext context, Peminjaman pinjam) async {
    DateTime selectedDate = DateTime.now();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Kembalikan Buku'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Pilih tanggal pengembalian:'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  if (selectedDate
                      .isBefore(DateTime.parse(pinjam.tanggalPinjam))) {
                    selectedDate = DateTime.parse(pinjam.tanggalPinjam);
                  }

                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.parse(pinjam.tanggalPinjam),
                    lastDate: DateTime.parse(pinjam.tanggalPinjam)
                        .add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
                child: Text(DateFormat('dd MMMM yyyy').format(selectedDate)),
              ),
              const SizedBox(height: 8),
              Text(
                'Keterlambatan: ${pinjam.hitungKeterlambatan(DateFormat('yyyy-MM-dd').format(selectedDate))} hari',
              ),
              Text(
                'Denda: Rp ${pinjam.hitungDenda(DateFormat('yyyy-MM-dd').format(selectedDate))}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      if (!context.mounted) return;

      try {
        final response =
            await Provider.of<PengembalianProvider>(context, listen: false)
                .prosesPengembalian(
          pinjam.id,
          DateFormat('yyyy-MM-dd').format(selectedDate),
        );

        if (!context.mounted) return;

        if (response['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Buku berhasil dikembalikan. Denda: Rp ${response['denda']}',
              ),
            ),
          );
          // Refresh data peminjaman
          Provider.of<PeminjamanProvider>(context, listen: false).initialData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response['message']}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
