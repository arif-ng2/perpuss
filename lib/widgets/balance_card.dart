import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class BalanceCard extends StatelessWidget {
  final String title;
  final double balance;
  final double? targetAmount;
  final DateTime lastUpdated;
  final VoidCallback? onTap;

  const BalanceCard({
    super.key,
    required this.title,
    required this.balance,
    this.targetAmount,
    required this.lastUpdated,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = targetAmount != null && targetAmount! > 0
        ? (balance / targetAmount!).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.gradientDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Update: ${DateFormat('dd/MM/yyyy HH:mm').format(lastUpdated)}',
                        style: TextStyle(
                          color: Colors.white.withAlpha(204),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          balance >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          balance >= 0 ? 'Surplus' : 'Defisit',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                NumberFormat.currency(
                  locale: 'id',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (targetAmount != null && targetAmount! > 0) ...[
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Target: ${NumberFormat.currency(
                            locale: 'id',
                            symbol: 'Rp ',
                            decimalDigits: 0,
                          ).format(targetAmount)}',
                          style: TextStyle(
                            color: Colors.white.withAlpha(230),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: Colors.white.withAlpha(230),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progress,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 