import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedCategory = 'Terbaru';
  final BookService _bookService = BookService();
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    if (!mounted) return;
    
    try {
      final books = await _bookService.getBooks();
      if (!mounted) return;
      
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      debugPrint('Error loading books: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF0C356A),
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Profile and Notification Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Profile Section
                            Row(
                              children: [
                                // Profile Picture
                                Consumer<AuthProvider>(
                                  builder: (context, auth, _) => Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: auth.foto != null && auth.foto!.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: auth.foto!,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => const CircularProgressIndicator(),
                                              errorWidget: (context, url, error) {
                                                print('Error loading image: $error');
                                                return const Icon(
                                                  Icons.person,
                                                  size: 30,
                                                  color: Colors.white,
                                                );
                                              },
                                            )
                                          : const Icon(
                                              Icons.person,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Greeting and Status
                                _buildGreetingRow(),
                              ],
                            ),
                            // Notification Bell
                            Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    // Handle notification tap
                                  },
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              color: Colors.white
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari pustaka terdekat',
                              hintStyle: TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.white.withOpacity(0.7),
                              ),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.search,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Banner Section with Dots Indicator
                        Stack(
                          children: [
                            SizedBox(
                              height: 150,
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/banner/banner${index + 1}.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Dots Indicator
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  2,
                                  (index) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentPage == index
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Book Categories Section
                        Column(
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Buku',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle lihat semua
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        'Lihat semua',
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white70,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15 ),
                            // Category Tabs
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildCategoryTab('Terbaru', isSelected: _selectedCategory == 'Terbaru'),
                                  _buildCategoryTab('Populer', isSelected: _selectedCategory == 'Populer'),
                                  _buildCategoryTab('Paling banyak di pinjam', 
                                    isSelected: _selectedCategory == 'Paling banyak di pinjam'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Book List
                        SizedBox(
                          height: 420,
                          child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _books.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Tidak ada buku tersedia',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _books.length,
                                  itemBuilder: (context, index) {
                                    final book = _books[index];
                                    return GestureDetector(
                                      onTap: () => _showBookDetails(context, book),
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 16),
                                        width: 220,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Cover Buku
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: CachedNetworkImage(
                                                imageUrl: book.cover,
                                                width: 220,
                                                height: 320,
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
                                            const SizedBox(height: 8),
                                            // Judul Buku
                                            Text(
                                              book.judul,
                                              style: const TextStyle(
                                                fontFamily: 'Outfit',
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            // Pengarang
                                            Text(
                                              book.pengarang,
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                color: Colors.white.withOpacity(0.7),
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTab(String text, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedCategory = text;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Outfit',
                color: isSelected ? const Color(0xFF0C356A) : Colors.white,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Hello, ',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, auth, _) => Text(
                auth.userName ?? 'User',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Text(
              'Online',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 4),
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 4,
            ),
          ],
        ),
      ],
    );
  }

  void _showBookDetails(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover Buku
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: book.cover,
                          width: 180,
                          height: 260,
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
                    ),
                    const SizedBox(height: 20),
                    // Informasi Buku
                    Text(
                      book.judul,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C356A),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    _buildDetailRow('Pengarang', book.pengarang),
                    _buildDetailRow('Penerbit', book.penerbit),
                    _buildDetailRow('Tahun Terbit', book.tahunTerbit),
                    _buildDetailRow('Kategori', book.kategori),
                    const SizedBox(height: 20),
                    // Tombol Aksi
                    Consumer<AuthProvider>(
                      builder: (context, auth, _) => Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              if (auth.userId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Silakan login terlebih dahulu')),
                                );
                                return;
                              }
                              _toggleSaveBook(
                                context,
                                book.idBuku,
                                auth.userId!,
                                book.isSaved ? 'unsave' : 'save',
                              );
                            },
                            icon: Icon(
                              book.isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text(
                              book.isSaved ? 'Tersimpan' : 'Simpan',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0C356A),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tombol Close (X)
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF0C356A),
                    size: 20,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          const Text(' : '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleSaveBook(
    BuildContext context,
    int bukuId,
    int anggotaId,
    String action,
  ) async {
    final bookService = BookService();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    try {
      await bookService.toggleSaveBook(bukuId, anggotaId, action);
      
      if (!mounted) return;
      
      // Reload books untuk update status
      await _loadBooks();
      
      if (!mounted) return;
      
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Buku berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

