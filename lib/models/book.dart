class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String category;
  final double rating;
  bool isAvailable;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.isAvailable,
    required this.description,
  });

  // Konversi dari JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool,
      description: json['description'] as String,
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'isAvailable': isAvailable,
      'description': description,
    };
  }
} 