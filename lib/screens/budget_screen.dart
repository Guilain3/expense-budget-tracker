import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../db/hive_service.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _budgetController = TextEditingController();
  double _currentBudget = 0.0;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  void _loadBudget() {
    setState(() {
      _currentBudget = HiveService.getBudget();
      _budgetController.text = _currentBudget.toString();
    });
  }

  void _saveBudget() {
    double budget = double.tryParse(_budgetController.text) ?? 0.0;
    HiveService.setBudget(budget);
    setState(() => _currentBudget = budget);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Budget saved!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Monthly Budget")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Enter Monthly Budget"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBudget,
              child: const Text("Save Budget"),
            ),
            const SizedBox(height: 20),
            Text("Current Budget: \$${_currentBudget.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
