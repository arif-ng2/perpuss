import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/loan_model.dart';

class LoanProvider with ChangeNotifier {
  final List<LoanModel> _loans = [];
  List<LoanModel> get loans => _loans;

  Future<void> addLoan(LoanModel loan) async {
    _loans.add(loan);
    await _saveLoans();
    notifyListeners();
  }

  Future<void> returnBook(String loanId) async {
    final index = _loans.indexWhere((loan) => loan.id == loanId);
    if (index != -1) {
      final loan = _loans[index];
      _loans[index] = LoanModel(
        id: loan.id,
        bookId: loan.bookId,
        bookTitle: loan.bookTitle,
        bookAuthor: loan.bookAuthor,
        borrowerName: loan.borrowerName,
        loanDate: loan.loanDate,
        dueDate: loan.dueDate,
        returnDate: DateTime.now(),
        status: 'dikembalikan',
      );
      await _saveLoans();
      notifyListeners();
    }
  }

  List<LoanModel> getActiveLoans() {
    return _loans.where((loan) => loan.status == 'dipinjam').toList();
  }

  List<LoanModel> getLoanHistory() {
    return _loans.where((loan) => loan.status == 'dikembalikan').toList();
  }

  bool isBookBorrowed(String bookId) {
    return _loans.any((loan) => 
      loan.bookId == bookId && loan.status == 'dipinjam'
    );
  }

  Future<void> _saveLoans() async {
    final prefs = await SharedPreferences.getInstance();
    final loansJson = _loans.map((loan) => loan.toJson()).toList();
    await prefs.setString('loans', jsonEncode(loansJson));
  }

  Future<void> loadLoans() async {
    final prefs = await SharedPreferences.getInstance();
    final loansString = prefs.getString('loans');
    if (loansString != null) {
      final List<dynamic> decodedList = jsonDecode(loansString);
      _loans.clear();
      _loans.addAll(
        decodedList.map((item) => LoanModel.fromJson(item)).toList()
      );
      notifyListeners();
    }
  }
} 