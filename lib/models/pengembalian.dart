class Pengembalian {
  final int id;
  final String tanggalDikembalikan;
  final int terlambat;
  final double denda;
  final int peminjamanId;
  final String? tanggalPinjam;
  final String? tanggalKembali;
  final String? namaAnggota;
  final String? judulBuku;
  final String? cover;

  Pengembalian({
    required this.id,
    required this.tanggalDikembalikan,
    required this.terlambat,
    required this.denda,
    required this.peminjamanId,
    this.tanggalPinjam,
    this.tanggalKembali,
    this.namaAnggota,
    this.judulBuku,
    this.cover,
  });
} 