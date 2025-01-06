class BookModel {
  final String id;
  final String title;
  final String author;
  final String publisher;
  final int year;
  final String category;
  final String description;
  final String? imageUrl;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.year,
    required this.category,
    required this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publisher': publisher,
      'year': year,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      publisher: json['publisher'],
      year: json['year'],
      category: json['category'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
} 