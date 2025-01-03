import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/buku.dart';
import '../providers/peminjaman_provider.dart';
import '../providers/anggota_provider.dart';

class PinjamBukuPage extends StatefulWidget {
  final Buku buku;
  const PinjamBukuPage({super.key, required this.buku});

  @override
  State<PinjamBukuPage> createState() => _PinjamBukuPageState();
}

class _PinjamBukuPageState extends State<PinjamBukuPage> {
  DateTime? _tanggalPinjam;
  DateTime? _tanggalKembali;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context, bool isPinjam) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isPinjam) {
          _tanggalPinjam = picked;
          // Set tanggal kembali otomatis 7 hari setelah tanggal pinjam
          _tanggalKembali = picked.add(const Duration(days: 7));
        } else {
          _tanggalKembali = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final anggotaProvider = Provider.of<AnggotaProvider>(context);
    final currentAnggota = anggotaProvider.currentAnggota;

    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      appBar: AppBar(
        title: const Text('Pinjam Buku'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi Buku
            Text(
              widget.buku.judul,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pengarang: ${widget.buku.pengarang}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),

            // Form Peminjaman
            InkWell(
              onTap: () => _selectDate(context, true),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Pinjam',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _tanggalPinjam != null
                      ? "${_tanggalPinjam!.day}/${_tanggalPinjam!.month}/${_tanggalPinjam!.year}"
                      : 'Pilih Tanggal',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context, false),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Kembali',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _tanggalKembali != null
                      ? "${_tanggalKembali!.day}/${_tanggalKembali!.month}/${_tanggalKembali!.year}"
                      : 'Pilih Tanggal',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading || _tanggalPinjam == null || _tanggalKembali == null
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        final peminjamanProvider =
                            Provider.of<PeminjamanProvider>(context, listen: false);
                        
                        final success = await peminjamanProvider.addPeminjaman(
                          _tanggalPinjam!.toIso8601String().split('T')[0],
                          _tanggalKembali!.toIso8601String().split('T')[0],
                          currentAnggota!.id,
                          widget.buku.idBuku,
                        );

                        setState(() => _isLoading = false);

                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Peminjaman berhasil')),
                          );
                          Navigator.pop(context);
                        } else if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Gagal melakukan peminjaman')),
                          );
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Pinjam Buku'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 