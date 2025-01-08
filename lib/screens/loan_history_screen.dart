import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/loan.dart';
import '../providers/auth_provider.dart';
import '../providers/loan_provider.dart';

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({super.key});

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final username = context.read<AuthProvider>().username;
      if (username != null) {
        context.read<LoanProvider>().loadUserLoans(username);
      }
    });
  }

  Future<void> _handleReturn(Loan loan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pengembalian'),
        content: const Text('Apakah Anda yakin ingin mengembalikan buku ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
            child: const Text('Ya, Kembalikan'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<LoanProvider>().returnBook(loan.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Buku berhasil dikembalikan'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Peminjaman'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<LoanProvider>(
        builder: (context, loanProvider, child) {
          if (loanProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (loanProvider.loans.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat peminjaman'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loanProvider.loans.length,
            itemBuilder: (context, index) {
              final loan = loanProvider.loans[index];
              final book = loan.book;
              final isOverdue = loan.isOverdue && loan.status == 'dipinjam';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Buku
                          Container(
                            width: 80,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: book.imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: kIsWeb
                                        ? Image.network(
                                            book.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(
                                                Icons.book,
                                                size: 40,
                                                color: Colors.grey[400],
                                              );
                                            },
                                          )
                                        : Image.file(
                                            File(book.imageUrl),
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(
                                                Icons.book,
                                                size: 40,
                                                color: Colors.grey[400],
                                              );
                                            },
                                          ),
                                  )
                                : Icon(
                                    Icons.book,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                          ),
                          const SizedBox(width: 16),
                          // Informasi Buku
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  book.author,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: loan.status == 'dipinjam'
                                        ? isOverdue
                                            ? Colors.red[100]
                                            : Colors.blue[100]
                                        : Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    loan.status == 'dipinjam'
                                        ? isOverdue
                                            ? 'Terlambat'
                                            : 'Dipinjam'
                                        : 'Dikembalikan',
                                    style: TextStyle(
                                      color: loan.status == 'dipinjam'
                                          ? isOverdue
                                              ? Colors.red[900]
                                              : Colors.blue[900]
                                          : Colors.green[900],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Tanggal Peminjaman
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tanggal Pinjam',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  loan.borrowDate.split(' ')[0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tanggal Kembali',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  loan.dueDate.split(' ')[0],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isOverdue ? Colors.red : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (loan.returnDate != null)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dikembalikan',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    loan.returnDate!.split(' ')[0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (loan.status == 'dipinjam') ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _handleReturn(loan),
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Kembalikan Buku'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 