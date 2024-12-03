class Anggota {
  final int id;
  final String? nim;
  final String nama;
  final String? alamat;
  final String email;
  final int tingkat;
  final String? foto;

  Anggota({
    required this.id,
    this.nim,
    required this.nama,
    this.alamat,
    required this.email,
    required this.tingkat,
    this.foto,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: int.parse(json['id'].toString()),
      nim: json['nim'] as String?,
      nama: json['nama'] as String,
      alamat: json['alamat'] as String?,
      email: json['email'] as String,
      tingkat: int.parse(json['tingkat'].toString()),
      foto: json['foto'] as String?,
    );
  }

  Anggota copyWith({
    int? id,
    String? nim,
    String? nama,
    String? alamat,
    String? email,
    int? tingkat,
    String? foto,
  }) {
    return Anggota(
      id: id ?? this.id,
      nim: nim ?? this.nim,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      email: email ?? this.email,
      tingkat: tingkat ?? this.tingkat,
      foto: foto ?? this.foto,
    );
  }
}
