class Book {
  final int idBuku;
  final String judul;
  final String pengarang;
  final String penerbit;
  final String tahunTerbit;
  final String kategori;
  final String cover;
  final bool isSaved;

  Book({
    required this.idBuku,
    required this.judul,
    required this.pengarang,
    required this.penerbit,
    required this.tahunTerbit,
    required this.kategori,
    required this.cover,
    this.isSaved = false,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    String coverUrl = json['cover'] ?? '';
    
    // Jika cover sudah berupa URL lengkap, gunakan langsung
    if (coverUrl.startsWith('http')) {
      return Book(
        idBuku: int.parse(json['id_buku'].toString()),
        judul: json['judul'] as String,
        pengarang: json['pengarang'] as String,
        penerbit: json['penerbit'] ?? '',
        tahunTerbit: json['tahun_terbit'] ?? '',
        kategori: json['kategori'] ?? '',
        cover: coverUrl,
        isSaved: json['is_saved'] == '1' || json['is_saved'] == 1,
      );
    }

    // Jika bukan URL lengkap, tambahkan base URL
    return Book(
      idBuku: int.parse(json['id_buku'].toString()),
      judul: json['judul'] as String,
      pengarang: json['pengarang'] as String,
      penerbit: json['penerbit'] ?? '',
      tahunTerbit: json['tahun_terbit'] ?? '',
      kategori: json['kategori'] ?? '',
      cover: 'http://10.0.2.2/pustaka_2301082020/pustaka/uploads/$coverUrl',
      isSaved: json['is_saved'] == '1' || json['is_saved'] == 1,
    );
  }

  // Tambahkan getter untuk mendapatkan URL cover yang valid
  String get coverUrl {
    if (cover.isEmpty) return '';
    return cover;
  }
}
