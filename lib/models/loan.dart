class Loan {
  final String id;
  final String bookId;
  final String userId;
  final DateTime borrowDate;
  final DateTime dueDate;
  DateTime? returnDate;

  Loan({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
  });

  bool isOverdue() {
    if (returnDate != null) return false;
    return DateTime.now().isAfter(dueDate);
  }

  bool isReturned() {
    return returnDate != null;
  }

  String formatBorrowDate() {
    return '${borrowDate.day}/${borrowDate.month}/${borrowDate.year}';
  }

  String formatReturnDate() {
    if (returnDate == null) {
      return 'Belum dikembalikan';
    }
    return '${returnDate!.day}/${returnDate!.month}/${returnDate!.year}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'userId': userId,
      'borrowDate': borrowDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
    };
  }

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      bookId: json['bookId'],
      userId: json['userId'],
      borrowDate: DateTime.parse(json['borrowDate']),
      dueDate: DateTime.parse(json['dueDate']),
      returnDate: json['returnDate'] != null ? DateTime.parse(json['returnDate']) : null,
    );
  }
} 