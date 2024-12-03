import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/anggota_provider.dart';
import '../anggota_screen/login_screen.dart';
import 'settings_screen.dart';
import 'editProfile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _logout() {
    context.read<AnggotaProvider>().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final anggota = context.watch<AnggotaProvider>();
    
    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Header dengan tombol edit
              Consumer<AnggotaProvider>(
                builder: (context, anggota, _) => Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: anggota.foto != null && anggota.foto!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: anggota.foto!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) {
                                  print('Error loading image: $error');
                                  return const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Color(0xFF0C356A),
                                  );
                                },
                              )
                            : const Icon(
                                Icons.person,
                                size: 50,
                                color: Color(0xFF0C356A),
                              ),
                      ),
                    ),
                    // Tombol edit di pojok kanan bawah avatar
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Color(0xFF0C356A),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                anggota.userName ?? 'User Name',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                anggota.email ?? 'email@example.com',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              
              // Menu Items
              _buildMenuItem(
                icon: Icons.history,
                title: 'Riwayat Peminjaman',
                onTap: () {
                  // TODO: Navigate to loan history screen
                },
              ),
              _buildMenuItem(
                icon: Icons.settings,
                title: 'Pengaturan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              const Spacer(),
              
              // Logout Button
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF0C356A),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF0C356A),
        ),
        onTap: onTap,
      ),
    );
  }
}
