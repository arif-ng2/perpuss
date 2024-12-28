import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/student.dart';
import 'models/class_fund.dart';
import 'models/monthly_report.dart';
import 'models/payment.dart';
import 'screens/student_list_screen.dart';
import 'screens/monthly_report_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/balance_card.dart';
import 'widgets/add_payment_dialog.dart';
import 'widgets/add_expense_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(ClassFundAdapter());
  Hive.registerAdapter(MonthlyReportAdapter());
  Hive.registerAdapter(PaymentAdapter());
  Hive.registerAdapter(PaymentTypeAdapter());

  // Open boxes
  await Hive.openBox<Student>('students');
  await Hive.openBox<ClassFund>('class_fund');
  await Hive.openBox<MonthlyReport>('monthly_reports');
  await Hive.openBox<Payment>('payments');

  // Initialize class fund if not exists
  final classFundBox = Hive.box<ClassFund>('class_fund');
  if (classFundBox.isEmpty) {
    await classFundBox.put(
      'current',
      ClassFund(
        balance: 0,
        lastUpdated: DateTime.now(),
        targetAmount: 0,
        description: 'Dana Kelas',
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cash Mee',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _studentsBox = Hive.box<Student>('students');
  final _classFundBox = Hive.box<ClassFund>('class_fund');
  final _monthlyReportsBox = Hive.box<MonthlyReport>('monthly_reports');
  final _paymentsBox = Hive.box<Payment>('payments');
  
  void _addStudent() async {
    final nameController = TextEditingController();
    final studentIdController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Mahasiswa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Mahasiswa',
                hintText: 'Masukkan nama mahasiswa',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: studentIdController,
              decoration: const InputDecoration(
                labelText: 'NIM',
                hintText: 'Masukkan NIM mahasiswa',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.isEmpty ||
                  studentIdController.text.isEmpty) {
                return;
              }
              Navigator.pop(context, true);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result == true) {
      final student = Student(
        name: nameController.text,
        studentId: studentIdController.text,
        balance: 0,
        transactionIds: [],
      );

      await _studentsBox.add(student);
      setState(() {});
    }
  }

  void _editStudent(Student student, int index) async {
    final nameController = TextEditingController(text: student.name);
    final studentIdController = TextEditingController(text: student.studentId);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Mahasiswa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Mahasiswa',
                hintText: 'Masukkan nama mahasiswa',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: studentIdController,
              decoration: const InputDecoration(
                labelText: 'NIM',
                hintText: 'Masukkan NIM mahasiswa',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.isEmpty ||
                  studentIdController.text.isEmpty) {
                return;
              }
              Navigator.pop(context, true);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result == true) {
      final updatedStudent = Student(
        name: nameController.text,
        studentId: studentIdController.text,
        balance: student.balance,
        transactionIds: student.transactionIds,
      );

      await _studentsBox.putAt(index, updatedStudent);
      setState(() {});
    }
  }

  void _deleteStudent(int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Mahasiswa'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus mahasiswa ini? '
          'Semua data transaksi akan ikut terhapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (result == true) {
      final student = _studentsBox.getAt(index);
      if (student != null) {
        // Hapus semua pembayaran terkait
        final payments = _paymentsBox.values
            .where((p) => p.studentId == student.studentId)
            .toList();
        for (final payment in payments) {
          await payment.delete();
        }
      }
      await _studentsBox.deleteAt(index);
      setState(() {});
    }
  }

  void _editClassFund() async {
    final currentFund = _classFundBox.get('current')!;
    final targetController = TextEditingController(
      text: currentFund.targetAmount.toString(),
    );
    final descController = TextEditingController(
      text: currentFund.description,
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Target Dana'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: targetController,
              decoration: const InputDecoration(
                labelText: 'Target Dana',
                hintText: 'Masukkan target dana',
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Masukkan deskripsi',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (targetController.text.isEmpty || descController.text.isEmpty) {
                return;
              }
              Navigator.pop(context, true);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result == true) {
      final updatedFund = ClassFund(
        balance: currentFund.balance,
        lastUpdated: currentFund.lastUpdated,
        targetAmount: double.parse(targetController.text.replaceAll(',', '')),
        description: descController.text,
      );

      await _classFundBox.put('current', updatedFund);
      setState(() {});
    }
  }

  void _editMonthlyReport(MonthlyReport report) async {
    final notesController = TextEditingController(text: report.notes);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Catatan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              report.formattedMonth,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Catatan',
                hintText: 'Masukkan catatan untuk bulan ini',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result == true) {
      report.notes = notesController.text;
      await report.save();
      setState(() {});
    }
  }

  void _addPayment(Student student) async {
    final payment = await showDialog<Payment>(
      context: context,
      builder: (context) => AddPaymentDialog(
        studentId: student.studentId,
        studentName: student.name,
      ),
    );

    if (payment != null) {
      // Simpan pembayaran
      await _paymentsBox.add(payment);

      // Update saldo mahasiswa
      student.balance += payment.amount;
      await student.save();

      // Update saldo kelas
      final classFund = _classFundBox.get('current')!;
      classFund.balance += payment.amount;
      classFund.lastUpdated = DateTime.now();
      await classFund.save();

      // Update atau buat laporan bulanan
      final month = DateTime(payment.date.year, payment.date.month);
      final report = _monthlyReportsBox.values.firstWhere(
        (r) => r.month.year == month.year && r.month.month == month.month,
        orElse: () => MonthlyReport(
          month: month,
          totalIncome: 0,
          totalExpense: 0,
          balance: 0,
        ),
      );

      report.totalIncome += payment.amount;
      report.balance = report.totalIncome - report.totalExpense;
      
      if (!report.isInBox) {
        await _monthlyReportsBox.add(report);
      } else {
        await report.save();
      }

      setState(() {});
    }
  }

  void _addExpense() async {
    final expense = await showDialog<Payment>(
      context: context,
      builder: (context) => const AddExpenseDialog(),
    );

    if (expense != null) {
      // Simpan pengeluaran
      await _paymentsBox.add(expense);

      // Update saldo kelas
      final classFund = _classFundBox.get('current')!;
      classFund.balance += expense.amount; // amount sudah negatif
      classFund.lastUpdated = DateTime.now();
      await classFund.save();

      // Update atau buat laporan bulanan
      final month = DateTime(expense.date.year, expense.date.month);
      final report = _monthlyReportsBox.values.firstWhere(
        (r) => r.month.year == month.year && r.month.month == month.month,
        orElse: () => MonthlyReport(
          month: month,
          totalIncome: 0,
          totalExpense: 0,
          balance: 0,
        ),
      );

      report.totalExpense += -expense.amount; // amount negatif, jadi dikali -1
      report.balance = report.totalIncome - report.totalExpense;
      
      if (!report.isInBox) {
        await _monthlyReportsBox.add(report);
      } else {
        await report.save();
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cash Mee'),
          actions: [
            IconButton(
              onPressed: _addStudent,
              icon: const Icon(Icons.person_add),
              tooltip: 'Tambah Mahasiswa',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ringkasan'),
              Tab(text: 'Mahasiswa'),
              Tab(text: 'Pembukuan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Ringkasan
            SingleChildScrollView(
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _classFundBox.listenable(),
                    builder: (context, box, _) {
                      final classFund = box.get('current')!;
                      return Column(
                        children: [
                          BalanceCard(
                            title: classFund.description,
                            balance: classFund.balance,
                            targetAmount: classFund.targetAmount,
                            lastUpdated: classFund.lastUpdated,
                            onTap: _editClassFund,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: FilledButton.icon(
                              onPressed: _addExpense,
                              icon: const Icon(Icons.remove_circle_outline),
                              label: const Text('Tambah Pengeluaran'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            // Tab Mahasiswa
            ValueListenableBuilder(
              valueListenable: _studentsBox.listenable(),
              builder: (context, box, _) {
                final students = box.values.toList();
                return StudentListScreen(
                  students: students,
                  onEditStudent: (student) =>
                      _editStudent(student, students.indexOf(student)),
                  onDeleteStudent: (student) =>
                      _deleteStudent(students.indexOf(student)),
                  onAddPayment: _addPayment,
                );
              },
            ),
            // Tab Pembukuan
            ValueListenableBuilder(
              valueListenable: _monthlyReportsBox.listenable(),
              builder: (context, box, _) {
                final reports = box.values.toList()
                  ..sort((a, b) => b.month.compareTo(a.month));
                return MonthlyReportScreen(
                  reports: reports,
                  onEditReport: _editMonthlyReport,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
