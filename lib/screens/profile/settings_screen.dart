import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isNotificationEnabled = true;
  
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    
    return Scaffold(
      backgroundColor: const Color(0xFF0C356A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0C356A),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Profil Section
            const Text(
              'Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C356A),
              ),
            ),
            const SizedBox(height: 15),
            _buildProfileTile(auth),
            const Divider(height: 30),

            // Aplikasi Section
            const Text(
              'Aplikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C356A),
              ),
            ),
            const SizedBox(height: 15),
            _buildSettingsSwitchTile(
              icon: Icons.dark_mode,
              title: 'Mode Gelap',
              subtitle: 'Mengubah tampilan aplikasi menjadi gelap',
              value: _isDarkMode,
              onChanged: (value) {
                setState(() => _isDarkMode = value);
                // TODO: Implement dark mode logic
              },
            ),
            _buildSettingsSwitchTile(
              icon: Icons.notifications,
              title: 'Notifikasi',
              subtitle: 'Aktifkan/nonaktifkan notifikasi',
              value: _isNotificationEnabled,
              onChanged: (value) {
                setState(() => _isNotificationEnabled = value);
                // TODO: Implement notification logic
              },
            ),
            const Divider(height: 30),

            // Tentang Section
            const Text(
              'Tentang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C356A),
              ),
            ),
            const SizedBox(height: 15),
            _buildSettingsTile(
              icon: Icons.info,
              title: 'Tentang Aplikasi',
              subtitle: 'Informasi tentang aplikasi',
              onTap: () {
                // TODO: Show about dialog
              },
            ),
            _buildSettingsTile(
              icon: Icons.privacy_tip,
              title: 'Kebijakan Privasi',
              subtitle: 'Kebijakan privasi pengguna',
              onTap: () {
                // TODO: Show privacy policy
              },
            ),
            _buildSettingsTile(
              icon: Icons.help,
              title: 'Bantuan',
              subtitle: 'Panduan penggunaan aplikasi',
              onTap: () {
                // TODO: Show help/guide
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(AuthProvider auth) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xFF0C356A),
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          auth.userName ?? 'User Name',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              auth.email ?? 'email@example.com',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Level: ${auth.tingkat == 1 ? "Admin" : "Anggota"}',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.edit,
            color: Color(0xFF0C356A),
          ),
          onPressed: () {
            // TODO: Navigate to edit profile screen
          },
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
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
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
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

  Widget _buildSettingsSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Icon(
          icon,
          color: const Color(0xFF0C356A),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF0C356A),
      ),
    );
  }
}
