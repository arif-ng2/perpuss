import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../models/loan.dart';
import 'book_provider.dart';

class LoanProvider with ChangeNotifier {
  List<Loan> _loans = [];
  final BookProvider _bookProvider;

  LoanProvider(this._bookProvider) {
    loadLoans();
  }

  List<Loan> get loans => _loans;

  Future<void> loadLoans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loansJson = prefs.getStringList('loans') ?? [];
      _loans = loansJson.map((json) => Loan.fromJson(jsonDecode(json))).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading loans: $e');
    }
  }

  Future<void> saveLoans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loansJson = _loans.map((loan) => jsonEncode(loan.toJson())).toList();
      await prefs.setStringList('loans', loansJson);
    } catch (e) {
      debugPrint('Error saving loans: $e');
    }
  }

  Future<void> addLoan(Loan loan) async {
    try {
      _loans.add(loan);
      await saveLoans();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding loan: $e');
      rethrow;
    }
  }

  Future<void> returnBook(String loanId) async {
    try {
      final loanIndex = _loans.indexWhere((loan) => loan.id == loanId);
      if (loanIndex != -1) {
        _loans[loanIndex].returnDate = DateTime.now();
        await saveLoans();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error returning book: $e');
      rethrow;
    }
  }

  List<Loan> getLoansByUser(String userId) {
    return _loans.where((loan) => loan.userId == userId).toList();
  }

  Book? getBookById(String bookId) {
    return _bookProvider.getBookById(bookId);
  }

  bool isBookBorrowed(String bookId) {
    return _loans.any((loan) => 
      loan.bookId == bookId && 
      loan.returnDate == null
    );
  }
} 