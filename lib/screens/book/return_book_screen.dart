import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/peminjaman.dart';
import '../../providers/pengembalian_provider.dart';

class ReturnBookForm extends StatefulWidget {
  final Peminjaman peminjaman;

  const ReturnBookForm({Key? key, required this.peminjaman}) : super(key: key);

  @override
  State<ReturnBookForm> createState() => _ReturnBookFormState();
}

class _ReturnBookFormState extends State<ReturnBookForm> {
  DateTime _tanggalPengembalian = DateTime.now();
  bool _isLoading = false;
  double? _denda;

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalPengembalian,
      firstDate: DateTime.parse(widget.peminjaman.tanggalPinjam),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _tanggalPengembalian = picked;
      });
      _hitungDenda();
    }
  }

  void _hitungDenda() {
    final tanggalKembaliSeharusnya = DateTime.parse(widget.peminjaman.tanggalKembali);
    if (_tanggalPengembalian.isAfter(tanggalKembaliSeharusnya)) {
      final selisih = _tanggalPengembalian.difference(tanggalKembaliSeharusnya).inDays;
      setState(() {
        _denda = selisih * 1000; // Rp 1.000 per hari
      });
    } else {
      setState(() {
        _denda = 0;
      });
    }
  }

  Future<void> _kembalikanBuku() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    
    setState(() => _isLoading = true);
    
    try {
      final success = await context.read<PengembalianProvider>().createPengembalian(
        peminjamanId: widget.peminjaman.id,
        tanggalDikembalikan: DateFormat('yyyy-MM-dd').format(_tanggalPengembalian),
      );

      if (success) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              _denda != null && _denda! > 0
                  ? 'Buku berhasil dikembalikan. Denda: ${currencyFormat.format(_denda)}'
                  : 'Buku berhasil dikembalikan tanpa denda',
            ),
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
  void initState() {
    super.initState();
    _hitungDenda();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kembalikan Buku'),
        backgroundColor: const Color(0xFF0C356A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Peminjaman',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text('Judul: ${widget.peminjaman.judulBuku}'),
                    Text('Tanggal Pinjam: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.peminjaman.tanggalPinjam))}'),
                    Text('Batas Kembali: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.peminjaman.tanggalKembali))}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            ListTile(
              title: const Text('Tanggal Pengembalian'),
              subtitle: Text(DateFormat('dd MMMM yyyy').format(_tanggalPengembalian)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),

            if (_denda != null && _denda! > 0)
              Card(
                color: Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Denda Keterlambatan: ${currencyFormat.format(_denda)}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _kembalikanBuku,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C356A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Kembalikan Buku'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 