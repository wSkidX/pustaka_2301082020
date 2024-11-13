class Book {
  final int id;
  final String judul;
  final String pengarang;
  final String penerbit;
  final String tahunTerbit;
  final String kategori;
  final String cover;

  Book({
    required this.id,
    required this.judul,
    required this.pengarang,
    required this.penerbit,
    required this.tahunTerbit,
    required this.kategori,
    required this.cover,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: int.parse(json['id_buku'].toString()),
      judul: json['judul'] ?? '',
      pengarang: json['pengarang'] ?? '',
      penerbit: json['penerbit'] ?? '',
      tahunTerbit: json['tahun_terbit'] ?? '',
      kategori: json['kategori'] ?? '',
      cover: json['cover'] ?? '',
    );
  }
}
