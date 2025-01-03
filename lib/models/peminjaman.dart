class Peminjaman {
   int id;
   String tanggalPinjam;
   String tanggalKembali;
   int anggota;
   int buku;
   String namaAnggota;
   String judulBuku;
   String cover;

  Peminjaman({
    required this.id,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.anggota,
    required this.buku,
    required this.namaAnggota,
    required this.judulBuku,
    required this.cover,
  });
}
