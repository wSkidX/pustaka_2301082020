import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/buku.dart';
import '../providers/peminjaman_provider.dart';
import '../providers/anggota_provider.dart';

class FormPinjamBukuPage extends StatefulWidget {
  final Buku buku;

  const FormPinjamBukuPage({super.key, required this.buku});

  @override
  State<FormPinjamBukuPage> createState() => _FormPinjamBukuPageState();
}

class _FormPinjamBukuPageState extends State<FormPinjamBukuPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _hariPinjamController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Menggunakan AnggotaProvider untuk mendapatkan currentAnggota
        final anggotaProvider =
            Provider.of<AnggotaProvider>(context, listen: false);
        final currentAnggota = anggotaProvider.currentAnggota;

        if (currentAnggota == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Anda harus login terlebih dahulu')),
          );
          return;
        }

        // Cek jumlah peminjaman aktif
        final peminjamanProvider =
            Provider.of<PeminjamanProvider>(context, listen: false);
        final peminjamanAktif = peminjamanProvider
            .getPeminjamanByAnggota(currentAnggota.id)
            .where((peminjaman) => peminjaman.status == 'Dipinjam')
            .length;

        if (peminjamanAktif >= 2) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Anda sudah mencapai batas maksimal peminjaman (2 buku)')),
          );
          return;
        }

        // Proses peminjaman menggunakan PeminjamanProvider
        await peminjamanProvider.addPeminjaman(
          DateFormat('yyyy-MM-dd').format(_selectedDate),
          int.parse(_hariPinjamController.text),
          currentAnggota.id,
          widget.buku.idBuku,
        );

        // Tampilkan pesan sukses
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Peminjaman berhasil')),
        );

        // Kembali ke halaman sebelumnya
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final anggotaProvider = Provider.of<AnggotaProvider>(context);
    final currentAnggota = anggotaProvider.currentAnggota;

    // Cek status buku
    if (widget.buku.status == 'Dipinjam') {
      return Scaffold(
        backgroundColor: const Color(0xFF0C356A),
        appBar: AppBar(
          title: const Text('Form Peminjaman Buku'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'Buku sedang dipinjam',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      appBar: AppBar(
        title: const Text('Form Peminjaman Buku'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Peminjam
              if (currentAnggota != null) ...[
                Text(
                  'Peminjam: ${currentAnggota.nama}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Judul Buku
              Text(
                widget.buku.judul,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Tanggal Pinjam
              const Text(
                'Tanggal Pinjam',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    DateFormat('dd MMMM yyyy').format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0C356A),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Hari Pinjam
              const Text(
                'Lama Peminjaman (Hari)',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _hariPinjamController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan jumlah hari',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harap masukkan jumlah hari';
                    }
                    final hari = int.tryParse(value);
                    if (hari == null || hari <= 0) {
                      return 'Masukkan jumlah hari yang valid';
                    }
                    if (hari > 14) {
                      return 'Maksimal peminjaman 14 hari';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: currentAnggota != null ? _submitForm : null,
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
      ),
    );
  }

  @override
  void dispose() {
    _hariPinjamController.dispose();
    super.dispose();
  }
}
