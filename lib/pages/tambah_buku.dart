import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/buku_provider.dart';
import '../models/buku.dart';

class TambahBukuPage extends StatefulWidget {
  const TambahBukuPage({super.key});

  @override
  State<TambahBukuPage> createState() => _TambahBukuPageState();
}

class _TambahBukuPageState extends State<TambahBukuPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _penulisController = TextEditingController();
  final _penerbitController = TextEditingController();
  final _tahunController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _coverController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _judulController.dispose();
    _penulisController.dispose();
    _penerbitController.dispose();
    _tahunController.dispose();
    _kategoriController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      appBar: AppBar(
        title: const Text('Tambah Buku'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Preview Cover
              if (_coverController.text.isNotEmpty)
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(_coverController.text),
                      fit: BoxFit.cover,
                      onError: (_, __) => const Icon(Icons.error),
                    ),
                  ),
                ),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _judulController,
                        decoration: const InputDecoration(
                          labelText: 'Judul Buku',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _penulisController,
                        decoration: const InputDecoration(
                          labelText: 'Penulis',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Penulis tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _penerbitController,
                        decoration: const InputDecoration(
                          labelText: 'Penerbit',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Penerbit tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tahunController,
                        decoration: const InputDecoration(
                          labelText: 'Tahun Terbit',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tahun terbit tidak boleh kosong';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Tahun harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _kategoriController,
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kategori tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _coverController,
                        decoration: const InputDecoration(
                          labelText: 'URL Cover',
                          hintText: 'Masukkan URL gambar cover',
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final bukuProvider = Provider.of<BukuProvider>(context, listen: false);
        final buku = Buku(
          idBuku: 0,
          judul: _judulController.text,
          pengarang: _penulisController.text,
          penerbit: _penerbitController.text,
          tahunTerbit: _tahunController.text,
          kategori: _kategoriController.text,
          cover: _coverController.text,
          deskripsi: '',
        );

        await bukuProvider.addBuku(
          buku.judul, 
          buku.pengarang, 
          buku.penerbit, 
          buku.tahunTerbit, 
          buku.kategori, 
          buku.cover,
          buku.deskripsi,
        );

        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menambahkan buku'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
