import 'package:hive/hive.dart';

part 'class_fund.g.dart';

@HiveType(typeId: 3)
class ClassFund extends HiveObject {
  @HiveField(0)
  double balance;

  @HiveField(1)
  DateTime lastUpdated;

  @HiveField(2)
  double targetAmount;

  @HiveField(3)
  String description;

  ClassFund({
    required this.balance,
    required this.lastUpdated,
    required this.targetAmount,
    required this.description,
  });
} 