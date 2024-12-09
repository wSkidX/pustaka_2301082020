class Peminjaman {
  final int id;
  final String tanggalPinjam;
  final String tanggalKembali;
  final int anggota;
  final int buku;
  final String? namaAnggota;
  final String? judulBuku;
  final String? cover;

  Peminjaman({
    required this.id,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.anggota,
    required this.buku,
    this.namaAnggota,
    this.judulBuku,
    this.cover,
  });
}
