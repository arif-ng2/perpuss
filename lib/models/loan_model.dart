class LoanModel {
  final String id;
  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final String borrowerName;
  final DateTime loanDate;
  final DateTime dueDate;
  final DateTime? returnDate;
  final String status; // 'dipinjam' atau 'dikembalikan'

  LoanModel({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.borrowerName,
    required this.loanDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'bookAuthor': bookAuthor,
      'borrowerName': borrowerName,
      'loanDate': loanDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'status': status,
    };
  }

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'],
      bookId: json['bookId'],
      bookTitle: json['bookTitle'],
      bookAuthor: json['bookAuthor'],
      borrowerName: json['borrowerName'],
      loanDate: DateTime.parse(json['loanDate']),
      dueDate: DateTime.parse(json['dueDate']),
      returnDate: json['returnDate'] != null 
          ? DateTime.parse(json['returnDate'])
          : null,
      status: json['status'],
    );
  }
} 