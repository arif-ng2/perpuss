import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 1)
class Student extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String studentId;

  @HiveField(2)
  double balance;

  @HiveField(3)
  List<String> transactionIds;

  Student({
    required this.name, 
    required this.studentId,
    this.balance = 0,
    List<String>? transactionIds,
  }) : transactionIds = transactionIds ?? [];
} 