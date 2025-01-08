class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String category;
  final double rating;
  final bool isAvailable;
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

  // Konversi dari Map (untuk SharedPreferences)
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      imageUrl: map['imageUrl'] as String,
      category: map['category'] as String,
      rating: map['rating'] as double,
      isAvailable: map['isAvailable'] as bool,
      description: map['description'] as String,
    );
  }

  // Konversi ke Map (untuk SharedPreferences)
  Map<String, dynamic> toMap() {
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