class Anggota {
  int id;
  String nim;
  String nama;
  String alamat;
  String email;
  String password;
  int tingkat;
  String foto;

  // Constructor
  Anggota({
    required this.id,
    required this.nim,
    required this.nama,
    required this.alamat,
    required this.email,
    required this.password,
    required this.tingkat,
    required this.foto,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: int.parse(json['id'].toString()),
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      tingkat: int.parse(json['tingkat'].toString()),
      foto: json['foto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nim': nim,
      'nama': nama,
      'alamat': alamat,
      'email': email,
      'password': password,
      'tingkat': tingkat,
      'foto': foto,
    };
  }
}
