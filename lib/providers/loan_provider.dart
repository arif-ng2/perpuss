import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';
import '../models/book.dart';
import '../models/loan.dart';
import 'book_provider.dart';

class LoanProvider with ChangeNotifier {
  final BookProvider _bookProvider;
  List<Loan> _loans = [];
  bool _isLoading = false;
  static const String _loansKey = 'loans';

  LoanProvider(this._bookProvider);

  List<Loan> get loans => _loans;
  bool get isLoading => _isLoading;

  Future<void> loadUserLoans(String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final loansJson = prefs.getString(_loansKey);
      
      if (loansJson != null) {
        final loansList = List<Map<String, dynamic>>.from(json.decode(loansJson));
        _loans = loansList
            .where((loan) => loan['userId'] == username)
            .map((loan) {
              final book = _bookProvider.getBookById(loan['bookId']);
              if (book != null) {
                return Loan.fromJson(loan, book);
              }
              return null;
            })
            .whereType<Loan>()
            .toList();
      } else {
        _loans = [];
      }
    } catch (e) {
      debugPrint('Error loading loans: $e');
      _loans = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> borrowBook(String userId, Book book, DateTime borrowDate, DateTime dueDate) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loansJson = prefs.getString(_loansKey);
      final List<Map<String, dynamic>> loansList;
      
      if (loansJson != null) {
        loansList = List<Map<String, dynamic>>.from(json.decode(loansJson));
      } else {
        loansList = [];
      }

      // Cek apakah buku sedang dipinjam
      final isBookBorrowed = loansList.any((loan) => 
        loan['bookId'] == book.id && 
        loan['status'] == 'dipinjam'
      );

      if (isBookBorrowed) {
        throw Exception('Buku sedang dipinjam');
      }

      // Buat peminjaman baru
      final loan = Loan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        bookId: book.id,
        userId: userId,
        borrowDate: borrowDate.toString(),
        dueDate: dueDate.toString(),
        status: 'dipinjam',
        book: book,
      );

      loansList.add(loan.toJson());
      await prefs.setString(_loansKey, json.encode(loansList));

      // Update status buku
      book.isAvailable = false;
      await _bookProvider.updateBook(book);

      // Reload loans
      await loadUserLoans(userId);
    } catch (e) {
      debugPrint('Error borrowing book: $e');
      rethrow;
    }
  }

  Future<void> returnBook(String loanId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loansJson = prefs.getString(_loansKey);
      
      if (loansJson == null) return;

      final loansList = List<Map<String, dynamic>>.from(json.decode(loansJson));
      final loanIndex = loansList.indexWhere((loan) => loan['id'] == loanId);

      if (loanIndex == -1) return;

      // Update status peminjaman
      loansList[loanIndex]['status'] = 'dikembalikan';
      loansList[loanIndex]['returnDate'] = DateTime.now().toString();
      await prefs.setString(_loansKey, json.encode(loansList));

      // Update status buku
      final bookId = loansList[loanIndex]['bookId'];
      final book = _bookProvider.getBookById(bookId);
      if (book != null) {
        book.isAvailable = true;
        await _bookProvider.updateBook(book);
      }

      // Reload loans
      final userId = loansList[loanIndex]['userId'];
      await loadUserLoans(userId);
    } catch (e) {
      debugPrint('Error returning book: $e');
      rethrow;
    }
  }

  Future<List<Loan>> getUserActiveLoans(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loansJson = prefs.getString(_loansKey);
      
      if (loansJson == null) return [];

      final loansList = List<Map<String, dynamic>>.from(json.decode(loansJson));
      return loansList
          .where((loan) => 
            loan['userId'] == userId && 
            loan['status'] == 'dipinjam'
          )
          .map((loan) {
            final book = _bookProvider.getBookById(loan['bookId']);
            if (book != null) {
              return Loan.fromJson(loan, book);
            }
            return null;
          })
          .whereType<Loan>()
          .toList();
    } catch (e) {
      debugPrint('Error getting user active loans: $e');
      return [];
    }
  }

  bool canBorrowMore(String userId) {
    // Batasi maksimal 2 buku yang dapat dipinjam secara bersamaan
    return _loans.where((loan) => 
      loan.userId == userId && 
      loan.status == 'dipinjam'
    ).length < 2;
  }
} 