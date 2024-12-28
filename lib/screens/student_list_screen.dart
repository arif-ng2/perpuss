import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/student_card.dart';

class StudentListScreen extends StatelessWidget {
  final List<Student> students;
  final Function(Student) onEditStudent;
  final Function(Student) onDeleteStudent;
  final Function(Student) onAddPayment;

  const StudentListScreen({
    super.key,
    required this.students,
    required this.onEditStudent,
    required this.onDeleteStudent,
    required this.onAddPayment,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada mahasiswa',
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
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return StudentCard(
          student: student,
          onTap: () => _showStudentDetail(context, student),
          onEdit: () => onEditStudent(student),
          onDelete: () => onDeleteStudent(student),
          onAddPayment: () => onAddPayment(student),
        );
      },
    );
  }

  void _showStudentDetail(BuildContext context, Student student) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StudentDetailSheet(
        student: student,
      ),
    );
  }
}

class StudentDetailSheet extends StatelessWidget {
  final Student student;

  const StudentDetailSheet({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Informasi Mahasiswa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Total Pembayaran'),
            trailing: Text(
              'Rp ${student.balance}',
              style: TextStyle(
                color: student.balance >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('Jumlah Transaksi'),
            trailing: Text(
              '${student.transactionIds.length}x',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 