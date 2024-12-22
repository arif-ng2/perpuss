import 'menu_item.dart';

class Transaction {
  final String id;
  final DateTime date;
  final List<OrderItem> items;
  final double totalAmount;

  Transaction({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      date: DateTime.parse(json['date']),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'],
    );
  }
}

class OrderItem {
  final MenuItem menuItem;
  final int quantity;
  final double subtotal;

  OrderItem({
    required this.menuItem,
    required this.quantity,
    required this.subtotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem.toJson(),
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItem: MenuItem.fromJson(json['menuItem']),
      quantity: json['quantity'],
      subtotal: json['subtotal'],
    );
  }
} 