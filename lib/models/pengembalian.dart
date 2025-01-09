class Pengembalian {
  final int id;
  final String tanggalDikembalikan;
  final int terlambat;
  final double denda;
  final int peminjamanId;
  final String namaAnggota;
  final String judulBuku;
  final String coverBuku;
  final String tanggalPinjam;
  final int hariPinjam;

  Pengembalian({
    required this.id,
    required this.tanggalDikembalikan,
    required this.terlambat,
    required this.denda,
    required this.peminjamanId,
    required this.namaAnggota,
    required this.judulBuku,
    required this.coverBuku,
    required this.tanggalPinjam,
    required this.hariPinjam,
  });

  factory Pengembalian.fromJson(Map<String, dynamic> json) {
    return Pengembalian(
      id: int.parse(json['id'].toString()),
      tanggalDikembalikan: json['tanggal_dikembalikan'],
      terlambat: int.parse(json['terlambat'].toString()),
      denda: double.parse(json['denda'].toString()),
      peminjamanId: int.parse(json['peminjaman_id'].toString()),
      namaAnggota: json['nama_anggota'] ?? '',
      judulBuku: json['judul_buku'] ?? '',
      coverBuku: json['cover_buku'] ?? '',
      tanggalPinjam: json['tanggal_pinjam'] ?? '',
      hariPinjam: int.parse(json['hari_pinjam'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal_dikembalikan': tanggalDikembalikan,
      'terlambat': terlambat,
      'denda': denda,
      'peminjaman_id': peminjamanId,
      'nama_anggota': namaAnggota,
      'judul_buku': judulBuku,
      'cover_buku': coverBuku,
      'tanggal_pinjam': tanggalPinjam,
      'hari_pinjam': hariPinjam,
    };
  }

  // Helper method untuk format tanggal
  String get tanggalPinjamFormatted {
    final date = DateTime.parse(tanggalPinjam);
    return '${date.day}-${date.month}-${date.year}';
  }

  String get tanggalKembaliFormatted {
    final date = DateTime.parse(tanggalDikembalikan);
    return '${date.day}-${date.month}-${date.year}';
  }

  // Helper method untuk format denda
  String get dendaFormatted {
    return 'Rp ${denda.toStringAsFixed(0)}';
  }

  // Helper method untuk status keterlambatan
  String get statusKeterlambatan {
    if (terlambat > 0) {
      return 'Terlambat $terlambat hari';
    }
    return 'Tepat Waktu';
  }
}
