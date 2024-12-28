import 'package:hive/hive.dart';

part 'payment.g.dart';

@HiveType(typeId: 5)
enum PaymentType {
  @HiveField(0)
  cash,
  @HiveField(1)
  transfer
}

@HiveType(typeId: 6)
class Payment extends HiveObject {
  @HiveField(0)
  String studentId;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  double amount;

  @HiveField(3)
  PaymentType type;

  @HiveField(4)
  String description;

  @HiveField(5)
  String? proofImagePath;

  Payment({
    required this.studentId,
    required this.date,
    required this.amount,
    required this.type,
    required this.description,
    this.proofImagePath,
  });
} 