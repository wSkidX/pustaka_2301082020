import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/book.dart';
import '../../providers/peminjaman_provider.dart';
import '../../providers/anggota_provider.dart';

class BorrowBookScreen extends StatefulWidget {
  final Book book;

  const BorrowBookScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<BorrowBookScreen> createState() => _BorrowBookScreenState();
}

class _BorrowBookScreenState extends State<BorrowBookScreen> {
  DateTime _tanggalPinjam = DateTime.now();
  DateTime _tanggalKembali = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context, bool isPinjam) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPinjam ? _tanggalPinjam : _tanggalKembali,
      firstDate: isPinjam ? DateTime.now() : _tanggalPinjam,
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        if (isPinjam) {
          _tanggalPinjam = picked;
          // Update tanggal kembali jika tanggal pinjam lebih besar
          if (_tanggalKembali.isBefore(_tanggalPinjam)) {
            _tanggalKembali = _tanggalPinjam.add(const Duration(days: 7));
          }
        } else {
          _tanggalKembali = picked;
        }
      });
    }
  }

  Future<void> _pinjamBuku() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    
    setState(() => _isLoading = true);
    
    try {
      final anggotaId = context.read<AnggotaProvider>().userId;
      if (anggotaId == null) {
        throw Exception('Silakan login terlebih dahulu');
      }

      final success = await context.read<PeminjamanProvider>().createPeminjaman(
        anggotaId: anggotaId,
        bukuId: widget.book.idBuku,
        tanggalPinjam: DateFormat('yyyy-MM-dd').format(_tanggalPinjam),
        tanggalKembali: DateFormat('yyyy-MM-dd').format(_tanggalKembali),
      );

      if (success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil dipinjam'),
            backgroundColor: Colors.green,
          ),
        );
        navigator.pop();
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pinjam Buku'),
        backgroundColor: const Color(0xFF0C356A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Cover
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.book.cover,
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Book Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.book.judul,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text('Pengarang: ${widget.book.pengarang}'),
                          Text('Penerbit: ${widget.book.penerbit}'),
                          Text('Tahun: ${widget.book.tahunTerbit}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Tanggal Pinjam
            ListTile(
              title: const Text('Tanggal Pinjam'),
              subtitle: Text(DateFormat('dd MMMM yyyy').format(_tanggalPinjam)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            
            // Tanggal Kembali
            ListTile(
              title: const Text('Tanggal Kembali'),
              subtitle: Text(DateFormat('dd MMMM yyyy').format(_tanggalKembali)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            
            const SizedBox(height: 24),
            
            // Button Pinjam
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _pinjamBuku,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C356A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Pinjam Buku'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 