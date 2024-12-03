class Anggota {
  final int id;
  final String nama;
  final String email;
  final int tingkat;
  final String? foto;

  Anggota({
    required this.id,
    required this.nama,
    required this.email,
    required this.tingkat,
    this.foto,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: int.parse(json['id'].toString()),
      nama: json['nama'] as String,
      email: json['email'] as String,
      tingkat: int.parse(json['tingkat'].toString()),
      foto: json['foto'] as String?,
    );
  }

  Anggota copyWith({
    int? id,
    String? nama,
    String? email,
    int? tingkat,
    String? foto,
  }) {
    return Anggota(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      tingkat: tingkat ?? this.tingkat,
      foto: foto ?? this.foto,
    );
  }
}
