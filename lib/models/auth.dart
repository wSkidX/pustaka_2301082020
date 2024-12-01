class Auth {
  final int id;
  final String nama;
  final String email;
  final int tingkat;
  final String? foto;

  Auth({
    required this.id,
    required this.nama,
    required this.email,
    required this.tingkat,
    this.foto,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      id: int.parse(json['id'].toString()),
      nama: json['nama'] as String,
      email: json['email'] as String,
      tingkat: int.parse(json['tingkat'].toString()),
      foto: json['foto'] as String?,
    );
  }

  Auth copyWith({
    int? id,
    String? nama,
    String? email,
    int? tingkat,
    String? foto,
  }) {
    return Auth(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      tingkat: tingkat ?? this.tingkat,
      foto: foto ?? this.foto,
    );
  }
}
