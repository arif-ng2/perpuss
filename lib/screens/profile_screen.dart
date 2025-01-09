import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'return_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showAccountInfo(BuildContext context, String username) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informasi Akun'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Username'),
              subtitle: Text(username),
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Tanggal Bergabung'),
              subtitle: const Text('1 Januari 2024'),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Total Peminjaman'),
              subtitle: const Text('5 buku'),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Status'),
              subtitle: const Text('Anggota Aktif'),
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

  void _showSettings(BuildContext context) {
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Tema Gelap'),
              subtitle: Text(isDarkMode ? 'Aktif' : 'Nonaktif'),
              value: isDarkMode,
              onChanged: (value) {
                context.read<ThemeProvider>().toggleTheme();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Bahasa'),
              subtitle: const Text('Indonesia'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pengaturan bahasa akan segera hadir')),
                );
              },
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

  @override
  Widget build(BuildContext context) {
    final username = context.read<AuthProvider>().username;
    final isAdmin = context.read<AuthProvider>().isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi Profil
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isAdmin ? Colors.blue.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: isAdmin ? Colors.blue : Colors.green,
                    child: Text(
                      username?[0].toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username ?? 'User',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isAdmin ? 'Administrator' : 'Anggota',
                          style: TextStyle(
                            color: isAdmin ? Colors.blue : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu
            const Text(
              'Menu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Informasi Akun
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Informasi Akun'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showAccountInfo(context, username ?? 'User'),
              ),
            ),
            const SizedBox(height: 8),

            // Pengaturan
            Card(
              child: ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Pengaturan'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showSettings(context),
              ),
            ),
            const SizedBox(height: 8),
            
            // Riwayat Pengembalian
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Riwayat Pengembalian'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReturnHistoryScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Logout
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  context.read<AuthProvider>().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 