class Pengembalian {
  final int id;
  final DateTime? tanggalDikembalikan;
  final int? terlambat;
  final double? denda;
  final int peminjamanId;
  final String judulBuku;

  Pengembalian({
    required this.id,
    this.tanggalDikembalikan,
    this.terlambat,
    this.denda,
    required this.peminjamanId,
    required this.judulBuku,
  });

  factory Pengembalian.fromJson(Map<String, dynamic> json) {
    return Pengembalian(
      id: int.parse(json['id'].toString()),
      tanggalDikembalikan: json['tanggal_dikembalikan'] != null ? DateTime.parse(json['tanggal_dikembalikan']) : null,
      terlambat: json['terlambat'] != null ? int.parse(json['terlambat'].toString()) : null,
      denda: json['denda'] != null ? double.parse(json['denda'].toString()) : null,
      peminjamanId: int.parse(json['peminjaman_id'].toString()),
      judulBuku: json['judul_buku'] ?? '',
    );
  }
} 