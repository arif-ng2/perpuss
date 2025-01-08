import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  bool _isLoading = false;

  List<Book> get books => _filterBooks();
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  // Filter buku berdasarkan kategori dan pencarian
  List<Book> _filterBooks() {
    return _books.where((book) {
      final matchesCategory = _selectedCategory == 'Semua' || 
                            book.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
                          book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Set kategori yang dipilih
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Set query pencarian
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Load buku dari SharedPreferences
  Future<void> loadBooks() async {
    if (_isLoading) return;
    
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final booksJson = prefs.getStringList('books') ?? [];
      
      if (booksJson.isEmpty) {
        await _addSampleBooks();
      } else {
        _books = booksJson
            .map((json) => Book.fromMap(jsonDecode(json) as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading books: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tambah buku contoh
  Future<void> _addSampleBooks() async {
    final sampleBooks = [
      Book(
        id: '1',
        title: 'Harry Potter',
        author: 'J.K. Rowling',
        imageUrl: '',
        category: 'Fiksi',
        rating: 4.5,
        isAvailable: true,
        description: 'Kisah seorang penyihir muda yang belajar di sekolah sihir Hogwarts.',
      ),
      Book(
        id: '2',
        title: 'Rich Dad Poor Dad',
        author: 'Robert Kiyosaki',
        imageUrl: '',
        category: 'Non-fiksi',
        rating: 4.0,
        isAvailable: true,
        description: 'Buku tentang pendidikan finansial dan investasi.',
      ),
      Book(
        id: '3',
        title: 'Laskar Pelangi',
        author: 'Andrea Hirata',
        imageUrl: '',
        category: 'Fiksi',
        rating: 4.8,
        isAvailable: true,
        description: 'Kisah perjuangan anak-anak di Belitung untuk mendapatkan pendidikan.',
      ),
    ];

    _books = sampleBooks;
    await _saveBooks();
  }

  // Simpan buku ke SharedPreferences
  Future<void> _saveBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = _books
          .map((book) => jsonEncode(book.toMap()))
          .toList();
      await prefs.setStringList('books', booksJson);
    } catch (e) {
      debugPrint('Error saving books: $e');
    }
  }

  // Tambah buku baru
  Future<void> addBook(Book book) async {
    try {
      _books.add(book);
      await _saveBooks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding book: $e');
      rethrow;
    }
  }

  // Update buku yang sudah ada
  Future<void> updateBook(Book updatedBook) async {
    try {
      final index = _books.indexWhere((book) => book.id == updatedBook.id);
      if (index != -1) {
        _books[index] = updatedBook;
        await _saveBooks();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating book: $e');
      rethrow;
    }
  }

  // Update status ketersediaan buku
  Future<void> updateBookAvailability(String bookId, bool isAvailable) async {
    try {
      final index = _books.indexWhere((book) => book.id == bookId);
      if (index != -1) {
        final updatedBook = Book(
          id: _books[index].id,
          title: _books[index].title,
          author: _books[index].author,
          imageUrl: _books[index].imageUrl,
          category: _books[index].category,
          rating: _books[index].rating,
          isAvailable: isAvailable,
          description: _books[index].description,
        );
        _books[index] = updatedBook;
        await _saveBooks();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating book availability: $e');
      rethrow;
    }
  }

  // Hapus buku
  Future<void> deleteBook(String bookId) async {
    try {
      _books.removeWhere((book) => book.id == bookId);
      await _saveBooks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting book: $e');
      rethrow;
    }
  }

  // Get buku berdasarkan ID
  Book? getBookById(String bookId) {
    try {
      return _books.firstWhere((book) => book.id == bookId);
    } catch (e) {
      return null;
    }
  }
} 