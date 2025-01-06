import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anggota_provider.dart';
import '../pages/editprofile_page.dart';
import '../pages/tambah_buku.dart';
import '../pages/login_page.dart';
import 'package:flutter/cupertino.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final anggotaProvider = Provider.of<AnggotaProvider>(context);
    final currentAnggota = anggotaProvider.currentAnggota;

    if (currentAnggota == null) {
      return const Center(child: Text('Data tidak ditemukan'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Profil
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: Icon(
                  CupertinoIcons.person_circle_fill,
                  size: 100,
                  color: Color(0xFF0C356A),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Informasi Profil
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Informasi Profil',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(CupertinoIcons.number),
                      title: Text(currentAnggota.nim),
                    ),
                    ListTile(
                      leading: const Icon(CupertinoIcons.person),
                      title: Text(currentAnggota.nama),
                    ),
                    ListTile(
                      leading: const Icon(CupertinoIcons.location),
                      title: Text(currentAnggota.alamat),
                    ),
                    ListTile(
                      leading: const Icon(CupertinoIcons.mail),
                      title: Text(currentAnggota.email),
                    ),
                    const Divider(),
                    _buildProfileItem('Status',
                        currentAnggota.tingkat == 1 ? 'Admin' : 'Anggota'),
                  ],
                ),
              ),
            ),

            // Tambahkan tombol Tambah Buku jika user adalah admin
            if (currentAnggota.tingkat == 1) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TambahBukuPage(),
                      ),
                    );
                  },
                  child: const Text('Tambah Buku'),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Tombol Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  anggotaProvider.logout();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
