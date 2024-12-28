import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/monthly_report.dart';
import '../theme/app_theme.dart';

class MonthlyReportScreen extends StatelessWidget {
  final List<MonthlyReport> reports;
  final Function(MonthlyReport) onEditReport;

  const MonthlyReportScreen({
    super.key,
    required this.reports,
    required this.onEditReport,
  });

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada pembukuan',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: () => onEditReport(report),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        report.formattedMonth,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: report.balance >= 0
                              ? AppTheme.successColor.withAlpha(26)
                              : AppTheme.errorColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          report.balance >= 0 ? 'Surplus' : 'Defisit',
                          style: TextStyle(
                            color: report.balance >= 0
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildReportRow(
                    'Pemasukan',
                    report.totalIncome,
                    AppTheme.successColor,
                  ),
                  const SizedBox(height: 8),
                  _buildReportRow(
                    'Pengeluaran',
                    report.totalExpense,
                    AppTheme.errorColor,
                  ),
                  const SizedBox(height: 8),
                  _buildReportRow(
                    'Saldo',
                    report.balance,
                    report.balance >= 0
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                  if (report.notes.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Catatan:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.notes,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportRow(String label, double amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          NumberFormat.currency(
            locale: 'id',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(amount),
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 