import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import "package:intl/intl.dart";
import 'package:uuid/uuid.dart';
import '../db/hive_service.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedCategory = "Food";
  DateTime _selectedDate = DateTime.now();
  final _uuid = const Uuid();

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_amountController.text);
      double budget = HiveService.getBudget();
      double totalSpent = HiveService.getExpenses().fold(0, (sum, item) => sum + item.amount);

      if (totalSpent + amount > budget) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Warning! This will exceed your budget."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }

      final newExpense = Expense(
        id: _uuid.v4(),
        category: _selectedCategory,
        amount: amount,
        date: _selectedDate,
        note: _noteController.text,
      );

      HiveService.addExpense(newExpense).then((_) {
        Navigator.pop(context, true);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryDropdown(),
              const SizedBox(height: 12),
              _buildAmountField(),
              const SizedBox(height: 12),
              _buildDatePicker(),
              const SizedBox(height: 12),
              _buildNoteField(),
              const Spacer(),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(labelText: "Category"),
      items: ["Food", "Transport", "Shopping", "Bills", "Other"]
          .map((category) => DropdownMenuItem(value: category, child: Text(category)))
          .toList(),
      onChanged: (value) => setState(() => _selectedCategory = value!),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: "Amount"),
      validator: (value) => value!.isEmpty ? "Enter amount" : null,
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Text("Date: ${DateFormat.yMMMd().format(_selectedDate)}"),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() => _selectedDate = pickedDate);
        }
      },
    );
  }

  Widget _buildNoteField() {
    return TextFormField(
      controller: _noteController,
      decoration: const InputDecoration(labelText: "Note (Optional)"),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveExpense,
        child: const Text("Save Expense"),
      ),
    );
  }
}
