import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final String? studentName;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.studentName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? AppTheme.successColor : AppTheme.errorColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppTheme.subtitleColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(transaction.date),
                          style: const TextStyle(
                            color: AppTheme.subtitleColor,
                            fontSize: 12,
                          ),
                        ),
                        if (studentName != null) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.person,
                            size: 14,
                            color: AppTheme.subtitleColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            studentName!,
                            style: const TextStyle(
                              color: AppTheme.subtitleColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                NumberFormat.currency(
                  locale: 'id',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(transaction.amount),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 