import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/book_model.dart';

class BookProvider with ChangeNotifier {
  final List<BookModel> _books = [];
  List<BookModel> get books => _books;

  Future<void> addBook(BookModel book) async {
    _books.add(book);
    await _saveBooks();
    notifyListeners();
  }

  Future<void> updateBook(BookModel book) async {
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      _books[index] = book;
      await _saveBooks();
      notifyListeners();
    }
  }

  Future<void> deleteBook(String id) async {
    _books.removeWhere((book) => book.id == id);
    await _saveBooks();
    notifyListeners();
  }

  Future<void> _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final booksJson = _books.map((book) => book.toJson()).toList();
    await prefs.setString('books', jsonEncode(booksJson));
  }

  Future<void> loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final booksString = prefs.getString('books');
    if (booksString != null) {
      final List<dynamic> decodedList = jsonDecode(booksString);
      _books.clear();
      _books.addAll(
        decodedList.map((item) => BookModel.fromJson(item)).toList()
      );
      notifyListeners();
    }
  }

  List<BookModel> searchBooks(String query) {
    return _books.where((book) =>
      book.title.toLowerCase().contains(query.toLowerCase()) ||
      book.author.toLowerCase().contains(query.toLowerCase()) ||
      book.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
} 