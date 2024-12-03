class Peminjaman {
  final int id;
  final String tanggalPinjam;
  final String tanggalKembali;
  final int anggotaId;
  final int bukuId;
  final String judulBuku;

  Peminjaman({
    required this.id,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.anggotaId,
    required this.bukuId,
    required this.judulBuku,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: int.parse(json['id'].toString()),
      tanggalPinjam: json['tanggal_pinjam'],
      tanggalKembali: json['tanggal_kembali'],
      anggotaId: int.parse(json['anggota'].toString()),
      bukuId: int.parse(json['buku'].toString()),
      judulBuku: json['judul_buku'] ?? '',
    );
  }
} 