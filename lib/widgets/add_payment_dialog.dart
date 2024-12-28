import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payment.dart';

class AddPaymentDialog extends StatefulWidget {
  final String studentId;
  final String studentName;

  const AddPaymentDialog({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  PaymentType _selectedType = PaymentType.cash;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Pembayaran'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.studentName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                hintText: 'Masukkan jumlah pembayaran',
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Keterangan',
                hintText: 'Masukkan keterangan pembayaran',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Jenis Pembayaran:'),
                const SizedBox(width: 16),
                SegmentedButton<PaymentType>(
                  segments: const [
                    ButtonSegment(
                      value: PaymentType.cash,
                      label: Text('Tunai'),
                      icon: Icon(Icons.money),
                    ),
                    ButtonSegment(
                      value: PaymentType.transfer,
                      label: Text('Transfer'),
                      icon: Icon(Icons.account_balance),
                    ),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (value) {
                    setState(() {
                      _selectedType = value.first;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      DateFormat('HH:mm').format(_selectedDate),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            if (_amountController.text.isEmpty || _descController.text.isEmpty) {
              return;
            }

            final payment = Payment(
              studentId: widget.studentId,
              date: _selectedDate,
              amount: double.parse(_amountController.text.replaceAll(',', '')),
              type: _selectedType,
              description: _descController.text,
            );

            Navigator.pop(context, payment);
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
} 