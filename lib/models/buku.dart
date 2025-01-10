class Buku {
  int idBuku;
  String judul;
  String pengarang;
  String penerbit;
  String tahunTerbit;
  String kategori;
  String cover;
  String deskripsi;
  String status;

  // Constructor
  Buku({
    required this.idBuku,
    required this.judul,
    required this.pengarang,
    required this.penerbit,
    required this.tahunTerbit,
    required this.kategori,
    required this.cover,
    required this.deskripsi,
    this.status = 'Tersedia',
  });

  
  // Factory method untuk membuat objek dari JSON
  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      idBuku: int.parse(json['id_buku'].toString()),
      judul: json['judul'] ?? '',
      pengarang: json['pengarang'] ?? '',
      penerbit: json['penerbit'] ?? '',
      tahunTerbit: json['tahun_terbit'] ?? '',
      kategori: json['kategori'] ?? '',
      cover: json['cover'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      status: json['status'] ?? 'Tersedia',
    );
  }

  // Method untuk mengkonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id_buku': idBuku,
      'judul': judul,
      'pengarang': pengarang,
      'penerbit': penerbit,
      'tahun_terbit': tahunTerbit,
      'kategori': kategori,
      'cover': cover,
      'deskripsi': deskripsi,
      'status': status,
    };
  }
}
