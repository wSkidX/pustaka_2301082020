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

  static List<Pengembalian> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Pengembalian(
      id: int.parse(item['id'].toString()),
      tanggalDikembalikan: item['tanggal_dikembalikan'],
      terlambat: int.parse(item['terlambat'].toString()),
      denda: double.parse(item['denda'].toString()),
      peminjamanId: int.parse(item['peminjaman_id'].toString()),
      tanggalPinjam: item['tanggal_pinjam'],
      tanggalKembali: item['tanggal_kembali'],
      namaAnggota: item['nama_anggota'],
      judulBuku: item['judul_buku'],
      cover: item['cover'],
    )).toList();
  }
} 