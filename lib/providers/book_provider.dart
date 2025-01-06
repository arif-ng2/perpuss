import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/book_model.dart';

class BookProvider with ChangeNotifier {
  List<BookModel> _books = [];
  List<BookModel> get books => _books;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BookProvider() {
    // Inisialisasi tanpa memanggil loadBooks langsung
  }

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
    if (_isLoading) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final booksString = prefs.getString('books');
      
      if (booksString != null) {
        final List<dynamic> decodedList = jsonDecode(booksString);
        _books = decodedList.map((item) => BookModel.fromJson(item)).toList();
      } else {
        _books = [];
      }
    } catch (e) {
      debugPrint('Error loading books: $e');
      rethrow;
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