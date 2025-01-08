import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/loan.dart';
import '../providers/auth_provider.dart';
import '../providers/loan_provider.dart';

class LoanHistoryScreen extends StatelessWidget {
  const LoanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loanProvider = context.watch<LoanProvider>();
    final authProvider = context.watch<AuthProvider>();
    final userLoans = loanProvider.getLoansByUser(authProvider.username!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Peminjaman'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: userLoans.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat peminjaman',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userLoans.length,
              itemBuilder: (context, index) {
                final loan = userLoans[index];
                final book = loanProvider.getBookById(loan.bookId);
                if (book == null) return const SizedBox();

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
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
                                          color: Colors.grey[400],
                                        );
                                      },
                                    ),
                            )
                          : Icon(
                              Icons.book,
                              color: Colors.grey[400],
                            ),
                    ),
                    title: Text(
                      book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dipinjam: ${loan.formatBorrowDate()}'),
                        Text('Dikembalikan: ${loan.formatReturnDate()}'),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: loan.isOverdue()
                                ? Colors.red[100]
                                : loan.isReturned()
                                    ? Colors.green[100]
                                    : Colors.orange[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            loan.isOverdue()
                                ? 'Terlambat'
                                : loan.isReturned()
                                    ? 'Dikembalikan'
                                    : 'Dipinjam',
                            style: TextStyle(
                              color: loan.isOverdue()
                                  ? Colors.red[900]
                                  : loan.isReturned()
                                      ? Colors.green[900]
                                      : Colors.orange[900],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
} 