import 'package:hive/hive.dart';

part 'class_fund.g.dart';

@HiveType(typeId: 3)
class ClassFund extends HiveObject {
  @HiveField(0)
  double totalBalance;

  @HiveField(1)
  DateTime lastUpdated;

  @HiveField(2)
  double targetAmount;

  @HiveField(3)
  String description;

  ClassFund({
    this.totalBalance = 0,
    required this.lastUpdated,
    this.targetAmount = 0,
    this.description = '',
  });
} 