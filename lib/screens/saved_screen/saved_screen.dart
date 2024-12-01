import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final BookService _bookService = BookService();
  List<Book> _savedBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedBooks();
  }

  Future<void> _loadSavedBooks() async {
    if (!mounted) return;
    
    try {
      final books = await _bookService.getSavedBooks();
      if (!mounted) return;
      
      setState(() {
        _savedBooks = books;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      
      setState(() => _isLoading = false);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _unsaveBook(int bukuId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    try {
      await _bookService.toggleSaveBook(
        bukuId,
        0, // anggota_id
        'unsave', // action
      );
      
      await _loadSavedBooks();
      
      if (!mounted) return;
      
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Buku berhasil dihapus dari simpanan'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus buku: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0C356A),
        title: const Text(
          'Buku Tersimpan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _savedBooks.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada buku yang disimpan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _savedBooks.length,
                  itemBuilder: (context, index) {
                    final book = _savedBooks[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cover Buku
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: book.cover,
                                width: 100,
                                height: 150,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) {
                                  print('Error loading book cover: $error');
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.book,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Informasi Buku
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.judul,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0C356A),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildDetailText('Pengarang', book.pengarang),
                                  _buildDetailText('Penerbit', book.penerbit),
                                  _buildDetailText('Tahun', book.tahunTerbit.toString()),
                                  _buildDetailText('Kategori', book.kategori),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () => _unsaveBook(book.idBuku),
                                        icon: const Icon(
                                          Icons.bookmark_remove,
                                          color: Color(0xFF0C356A),
                                        ),
                                        label: const Text(
                                          'Hapus dari Simpanan',
                                          style: TextStyle(
                                            color: Color(0xFF0C356A),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 