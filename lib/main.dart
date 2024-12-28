import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'models/student.dart';
import 'models/transaction.dart';
import 'models/class_fund.dart';
import 'screens/student_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(ClassFundAdapter());
  
  await Hive.openBox<Student>('students');
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<ClassFund>('classFund');
  
  // Initialize class fund if not exists
  final classFundBox = Hive.box<ClassFund>('classFund');
  if (classFundBox.isEmpty) {
    classFundBox.add(ClassFund(
      lastUpdated: DateTime.now(),
      description: 'Kas Kelas Semester 1',
      targetAmount: 1000000,
    ));
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manajemen Keuangan Kelas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Box<Student> _studentsBox;
  late final Box<Transaction> _transactionsBox;
  late final Box<ClassFund> _classFundBox;
  
  @override
  void initState() {
    super.initState();
    _studentsBox = Hive.box('students');
    _transactionsBox = Hive.box('transactions');
    _classFundBox = Hive.box('classFund');
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      _transactionsBox.add(transaction);
      
      if (transaction.studentId != null) {
        final student = _studentsBox.get(transaction.studentId);
        if (student != null) {
          student.balance += transaction.type == TransactionType.income 
              ? transaction.amount 
              : -transaction.amount;
          student.transactionIds.add(transaction.id);
          student.save();
        }
      }
      
      // Update class fund
      final classFund = _classFundBox.getAt(0);
      if (classFund != null) {
        classFund.totalBalance += transaction.type == TransactionType.income 
            ? transaction.amount 
            : -transaction.amount;
        classFund.lastUpdated = DateTime.now();
        classFund.save();
      }
    });
  }

  void _addStudent(Student student) {
    setState(() {
      _studentsBox.add(student);
    });
  }

  void _showAddStudentDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Mahasiswa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Mahasiswa'),
            ),
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'NIM'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _addStudent(Student(
                name: nameController.text,
                studentId: idController.text,
              ));
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAddTransactionDialog([Student? student]) {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    TransactionType selectedType = TransactionType.income;
    Student? selectedStudent = student;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Transaksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (student == null)
              DropdownButton<Student>(
                value: selectedStudent,
                hint: const Text('Pilih Mahasiswa'),
                items: _studentsBox.values.map((student) {
                  return DropdownMenuItem(
                    value: student,
                    child: Text('${student.name} (${student.studentId})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStudent = value;
                  });
                },
              ),
            DropdownButton<TransactionType>(
              value: selectedType,
              items: TransactionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type == TransactionType.income ? 'Pemasukan' : 'Pengeluaran'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (selectedStudent != null) {
                _addTransaction(Transaction(
                  id: DateTime.now().toString(),
                  date: DateTime.now(),
                  description: descriptionController.text,
                  amount: double.parse(amountController.text),
                  type: selectedType,
                  studentId: selectedStudent!.studentId,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showSetTargetDialog() {
    final targetController = TextEditingController();
    final descController = TextEditingController();
    final classFund = _classFundBox.getAt(0);
    
    if (classFund != null) {
      targetController.text = classFund.targetAmount.toString();
      descController.text = classFund.description;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atur Target Kas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: targetController,
              decoration: const InputDecoration(
                labelText: 'Target Kas (Rp)',
                hintText: 'Contoh: 1000000',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Keterangan',
                hintText: 'Contoh: Kas Kelas Semester 1',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (classFund != null) {
                classFund.targetAmount = double.tryParse(targetController.text) ?? 0;
                classFund.description = descController.text;
                classFund.save();
              }
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen Keuangan Kelas'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ringkasan'),
              Tab(text: 'Mahasiswa'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: _showAddStudentDialog,
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showSetTargetDialog,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Tab Ringkasan
            ValueListenableBuilder(
              valueListenable: _classFundBox.listenable(),
              builder: (context, Box<ClassFund> box, _) {
                final classFund = box.getAt(0);
                if (classFund == null) return const SizedBox();
                
                final progress = classFund.targetAmount > 0 
                    ? (classFund.totalBalance / classFund.targetAmount).clamp(0.0, 1.0)
                    : 0.0;
                
                return Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      classFund.description,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Terakhir diperbarui: ${DateFormat('dd/MM/yyyy HH:mm').format(classFund.lastUpdated)}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  ).format(classFund.totalBalance),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: classFund.totalBalance >= 0 
                                        ? Colors.green 
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (classFund.targetAmount > 0) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Target: ${NumberFormat.currency(
                                            locale: 'id',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(classFund.targetAmount)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        LinearProgressIndicator(
                                          value: progress,
                                          backgroundColor: Colors.grey[200],
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            progress >= 1.0 ? Colors.green : Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${(progress * 100).toStringAsFixed(1)}% tercapai',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: _transactionsBox.listenable(),
                        builder: (context, Box<Transaction> box, _) {
                          final transactions = box.values.toList()
                            ..sort((a, b) => b.date.compareTo(a.date));
                            
                          if (transactions.isEmpty) {
                            return const Center(
                              child: Text(
                                'Belum ada transaksi',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            );
                          }
                          
                          return ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              final student = transaction.studentId != null 
                                  ? _studentsBox.get(transaction.studentId)
                                  : null;
                                  
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
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
                                    '${DateFormat('dd/MM/yyyy HH:mm').format(transaction.date)}'
                                    '${student != null ? '\n${student.name}' : ''}'
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
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            // Tab Mahasiswa
            ValueListenableBuilder(
              valueListenable: _studentsBox.listenable(),
              builder: (context, Box<Student> box, _) {
                final students = box.values.toList();
                return StudentListScreen(
                  students: students,
                  onAddPayment: (student) => _showAddTransactionDialog(student),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTransactionDialog(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
