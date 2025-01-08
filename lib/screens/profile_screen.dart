import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informasi Aplikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perpustakaan Digital',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Versi 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aplikasi ini dikembangkan untuk memudahkan pengelolaan dan peminjaman buku di perpustakaan.',
            ),
            const SizedBox(height: 8),
            Text(
              '© 2024 Perpustakaan Digital',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifikasi'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // TODO: Implementasi pengaturan notifikasi
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pengaturan notifikasi akan segera hadir'),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Bahasa'),
              trailing: const Text('Indonesia'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengaturan bahasa akan segera hadir'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Mode Gelap'),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  // TODO: Implementasi mode gelap
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mode gelap akan segera hadir'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bantuan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpSection(
              'Pencarian Buku',
              'Gunakan kolom pencarian di halaman utama untuk mencari buku berdasarkan judul, penulis, atau deskripsi.',
            ),
            const SizedBox(height: 16),
            _buildHelpSection(
              'Peminjaman Buku',
              'Klik pada buku yang ingin dipinjam, kemudian klik tombol "Pinjam" pada halaman detail buku.',
            ),
            const SizedBox(height: 16),
            _buildHelpSection(
              'Riwayat Peminjaman',
              'Klik ikon riwayat di pojok kanan atas untuk melihat daftar buku yang sedang atau pernah Anda pinjam.',
            ),
            const SizedBox(height: 16),
            _buildHelpSection(
              'Pengembalian Buku',
              'Pada halaman riwayat peminjaman, klik tombol "Kembalikan" pada buku yang ingin dikembalikan.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(content),
      ],
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AuthProvider>().username;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: const Color(0xFF1A237E),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  username ?? 'User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Anggota Perpustakaan',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Informasi'),
            subtitle: const Text('Tentang aplikasi dan versi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showInfoDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            subtitle: const Text('Notifikasi, bahasa, dan tampilan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSettingsDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Bantuan'),
            subtitle: const Text('Panduan penggunaan aplikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showHelpDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }
} 