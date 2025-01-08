import '../models/book.dart';

class Loan {
  final String id;
  final String bookId;
  final String userId;
  final String borrowDate;
  final String dueDate;
  final String? returnDate;
  final String status;
  final Book book;

  Loan({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
    required this.book,
  });

  bool get isOverdue {
    if (status != 'dipinjam') return false;
    final due = DateTime.parse(dueDate);
    return DateTime.now().isAfter(due);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'userId': userId,
      'borrowDate': borrowDate,
      'dueDate': dueDate,
      'returnDate': returnDate,
      'status': status,
    };
  }

  factory Loan.fromJson(Map<String, dynamic> json, Book book) {
    return Loan(
      id: json['id'],
      bookId: json['bookId'],
      userId: json['userId'],
      borrowDate: json['borrowDate'],
      dueDate: json['dueDate'],
      returnDate: json['returnDate'],
      status: json['status'],
      book: book,
    );
  }
} 