import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/student.dart';
import '../models/transaction.dart';

class StudentListScreen extends StatelessWidget {
  final List<Student> students;
  final Function(Student) onAddPayment;

  const StudentListScreen({
    super.key,
    required this.students,
    required this.onAddPayment,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(student.name),
            subtitle: Text('NIM: ${student.studentId}'),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormat.currency(
                    locale: 'id',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(student.balance),
                  style: TextStyle(
                    color: student.balance >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total Pembayaran',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            onTap: () => _showStudentDetail(context, student),
          ),
        );
      },
    );
  }

  void _showStudentDetail(BuildContext context, Student student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StudentDetailSheet(
        student: student,
        onAddPayment: onAddPayment,
      ),
    );
  }
}

class StudentDetailSheet extends StatelessWidget {
  final Student student;
  final Function(Student) onAddPayment;

  const StudentDetailSheet({
    super.key,
    required this.student,
    required this.onAddPayment,
  });

  @override
  Widget build(BuildContext context) {
    final transactionsBox = Hive.box<Transaction>('transactions');

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('NIM: ${student.studentId}'),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => onAddPayment(student),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Pembayaran'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat Pembayaran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'id',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(student.balance),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: student.balance >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (student.transactionIds.isEmpty)
              const Center(
                child: Text(
                  'Belum ada riwayat pembayaran',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: student.transactionIds.length,
                  itemBuilder: (context, index) {
                    final transactionId = student.transactionIds[index];
                    final transaction = transactionsBox.values.firstWhere(
                      (t) => t.id == transactionId,
                      orElse: () => Transaction(
                        id: '',
                        date: DateTime.now(),
                        description: 'Transaksi tidak ditemukan',
                        amount: 0,
                        type: TransactionType.income,
                      ),
                    );

                    return Card(
                      child: ListTile(
                        leading: Icon(
                          transaction.type == TransactionType.income
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: transaction.type == TransactionType.income
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: Text(transaction.description),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(transaction.date),
                        ),
                        trailing: Text(
                          NumberFormat.currency(
                            locale: 'id',
                            symbol: 'Rp ',
                            decimalDigits: 0,
                          ).format(transaction.amount),
                          style: TextStyle(
                            color: transaction.type == TransactionType.income
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
} 