class RegisterModel {
  final String nim;
  final String nama;
  final String alamat;
  final String email;
  final String password;
  final String? foto;

  RegisterModel({
    required this.nim,
    required this.nama,
    required this.alamat,
    required this.email,
    required this.password,
    this.foto,
  });

  // Method untuk mengkonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'nim': nim,
      'nama': nama,
      'alamat': alamat,
      'email': email,
      'password': password,
      'foto': foto ?? '',
      'tingkat': 1, // Default tingkat untuk anggota baru
    };
  }

  // Factory method untuk membuat objek dari JSON
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      foto: json['foto'],
    );
  }
}
