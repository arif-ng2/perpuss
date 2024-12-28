import 'package:hive/hive.dart';

part 'monthly_report.g.dart';

@HiveType(typeId: 4)
class MonthlyReport extends HiveObject {
  @HiveField(0)
  DateTime month;

  @HiveField(1)
  double totalIncome;

  @HiveField(2)
  double totalExpense;

  @HiveField(3)
  double balance;

  @HiveField(4)
  String notes;

  MonthlyReport({
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    this.notes = '',
  });

  String get formattedMonth {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${months[month.month - 1]} ${month.year}';
  }
} 