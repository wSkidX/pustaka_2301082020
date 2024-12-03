class Book {
  final int idBuku;
  final String judul;
  final String pengarang;
  final String penerbit;
  final String tahunTerbit;
  final String kategori;
  final String cover;
  final String deskripsi;
  final String bookBanner;
  final int ulasan;
  final bool isSaved;

  Book({
    required this.idBuku,
    required this.judul,
    required this.pengarang,
    required this.penerbit,
    required this.tahunTerbit,
    required this.kategori,
    required this.cover,
    required this.deskripsi,
    required this.bookBanner,
    required this.ulasan,
    this.isSaved = false,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    String sanitizeUrl(String? url) {
      if (url == null || url.isEmpty) return '';
      // Jika menggunakan emulator Android, ganti localhost dengan 10.0.2.2
      
      return url;
    }

    return Book(
      idBuku: int.parse(json['id_buku'].toString()),
      judul: json['judul'] as String,
      pengarang: json['pengarang'] as String,
      penerbit: json['penerbit'] as String,
      tahunTerbit: json['tahun_terbit'] as String,
      kategori: json['kategori'] as String,
      cover: sanitizeUrl(json['cover']),
      deskripsi: json['deskripsi'] as String,
      bookBanner: sanitizeUrl(json['book_banner']),
      ulasan: int.parse(json['ulasan']?.toString() ?? '0'),
      isSaved: json['is_saved'] == 1,
    );
  }
}
