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

  static List<Peminjaman> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Peminjaman(
      id: int.parse(item['id'].toString()),
      tanggalPinjam: item['tanggal_pinjam'],
      tanggalKembali: item['tanggal_kembali'],
      anggota: int.parse(item['anggota'].toString()),
      buku: int.parse(item['buku'].toString()),
      namaAnggota: item['nama_anggota'],
      judulBuku: item['judul_buku'],
      cover: item['cover'],
    )).toList();
  }
}
