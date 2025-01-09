class Peminjaman {
  int id;
  String tanggalPinjam;
  int hariPinjam;
  int anggota;
  int buku;
  String status;
  String? namaAnggota; // Tambahan untuk JOIN
  String? judulBuku; // Tambahan untuk JOIN

  Peminjaman({
    required this.id,
    required this.tanggalPinjam,
    required this.hariPinjam,
    required this.anggota,
    required this.buku,
    this.status = 'Dipinjam',
    this.namaAnggota,
    this.judulBuku,
  });

  // Getters
  int get getId => id;
  String get getTanggalPinjam => tanggalPinjam;
  int get getHariPinjam => hariPinjam;
  int get getAnggota => anggota;
  int get getBuku => buku;
  String get getStatus => status;
  String? get getNamaAnggota => namaAnggota;
  String? get getJudulBuku => judulBuku;

  // Setters
  set setId(int value) => id = value;
  set setTanggalPinjam(String value) => tanggalPinjam = value;
  set setHariPinjam(int value) => hariPinjam = value;
  set setAnggota(int value) => anggota = value;
  set setBuku(int value) => buku = value;
  set setStatus(String value) => status = value;
  set setNamaAnggota(String? value) => namaAnggota = value;
  set setJudulBuku(String? value) => judulBuku = value;

  // Factory method untuk membuat objek dari JSON
  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: int.parse(json['id'].toString()),
      tanggalPinjam: json['tanggal_pinjam'] ?? '',
      hariPinjam: int.parse(json['hari_pinjam'].toString()),
      anggota: int.parse(json['anggota'].toString()),
      buku: int.parse(json['buku'].toString()),
      status: json['status'] ?? 'Dipinjam',
      namaAnggota: json['nama_anggota'],
      judulBuku: json['judul_buku'],
    );
  }

  // Method untuk mengkonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal_pinjam': tanggalPinjam,
      'hari_pinjam': hariPinjam,
      'anggota': anggota,
      'buku': buku,
      'status': status,
      'nama_anggota': namaAnggota,
      'judul_buku': judulBuku,
    };
  }

  // Method untuk menghitung keterlambatan
  int hitungKeterlambatan(String tanggalKembali) {
    // Konversi string ke DateTime
    final tanggalPinjamDate = DateTime.parse(tanggalPinjam);
    final tanggalKembaliDate = DateTime.parse(tanggalKembali);

    // Hitung tanggal jatuh tempo
    final tanggalJatuhTempo = tanggalPinjamDate.add(Duration(days: hariPinjam));

    // Hitung selisih hari
    final selisihHari = tanggalKembaliDate.difference(tanggalJatuhTempo).inDays;

    // Jika selisih hari negatif atau 0, berarti tidak terlambat
    return selisihHari > 0 ? selisihHari : 0;
  }

  // Method untuk menghitung denda
  double hitungDenda(String tanggalKembali) {
    final keterlambatan = hitungKeterlambatan(tanggalKembali);
    return keterlambatan * 3000.0;
  }
}
