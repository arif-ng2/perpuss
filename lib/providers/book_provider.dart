import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  static const String _booksKey = 'books';

  BookProvider() {
    loadBooks();
  }

  List<Book> get books => _filteredBooks;
  bool get isLoading => _isLoading;

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _filterBooks();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _filterBooks();
  }

  void _filterBooks() {
    _filteredBooks = _books.where((book) {
      bool matchesSearch = _searchQuery.isEmpty ||
          book.title.toLowerCase().contains(_searchQuery) ||
          book.author.toLowerCase().contains(_searchQuery) ||
          book.description.toLowerCase().contains(_searchQuery);

      bool matchesCategory = _selectedCategory == 'Semua' ||
          _selectedCategory == 'Search' ||
          book.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    notifyListeners();
  }

  Future<void> loadBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = prefs.getString(_booksKey);
      
      if (booksJson != null) {
        final booksList = List<Map<String, dynamic>>.from(json.decode(booksJson));
        _books = booksList.map((book) => Book.fromJson(book)).toList();
      } else {
        // Tambahkan beberapa buku contoh jika belum ada data
        _books = [
          Book(
            id: '1',
            title: 'Flutter for Beginners',
            author: 'John Doe',
            imageUrl: '',
            category: 'Pendidikan',
            rating: 4.5,
            isAvailable: true,
            description: 'Buku panduan Flutter untuk pemula',
          ),
          Book(
            id: '2',
            title: 'Harry Potter',
            author: 'J.K. Rowling',
            imageUrl: '',
            category: 'Fiksi',
            rating: 5.0,
            isAvailable: true,
            description: 'Novel fantasi tentang dunia sihir',
          ),
          Book(
            id: '3',
            title: 'Rich Dad Poor Dad',
            author: 'Robert Kiyosaki',
            imageUrl: '',
            category: 'Bisnis',
            rating: 4.8,
            isAvailable: true,
            description: 'Buku tentang kecerdasan finansial',
          ),
        ];
        await saveBooks();
      }
      
      _filterBooks();
    } catch (e) {
      debugPrint('Error loading books: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = json.encode(_books.map((book) => book.toJson()).toList());
      await prefs.setString(_booksKey, booksJson);
    } catch (e) {
      debugPrint('Error saving books: $e');
    }
  }

  Future<void> addBook(Book book) async {
    try {
      _books.add(book);
      await saveBooks();
      _filterBooks();
    } catch (e) {
      debugPrint('Error adding book: $e');
      rethrow;
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      final index = _books.indexWhere((b) => b.id == book.id);
      if (index != -1) {
        _books[index] = book;
        await saveBooks();
        _filterBooks();
      }
    } catch (e) {
      debugPrint('Error updating book: $e');
      rethrow;
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      _books.removeWhere((book) => book.id == id);
      await saveBooks();
      _filterBooks();
    } catch (e) {
      debugPrint('Error deleting book: $e');
      rethrow;
    }
  }

  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
} 