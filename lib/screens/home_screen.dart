import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../db/hive_service.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_screen.dart';
import 'reports_screen.dart';
import 'budget_screen.dart';
import '../theme/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  void loadExpenses() {
    setState(() {
      expenses = HiveService.getExpenses();
    });
  }

  void _deleteExpense(String id) {
    HiveService.deleteExpense(id).then((_) => loadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    double totalSpent = expenses.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.money),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetScreen()));
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(totalSpent),
          _buildExpenseList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
          if (result == true) {
            loadExpenses(); // Refresh expenses after returning
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildSummaryCard(double totalSpent) {
    double budget = HiveService.getBudget();
    double remainingBalance = budget - totalSpent;
    bool isOverBudget = remainingBalance < 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOverBudget ? Colors.redAccent : Colors.blueAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monthly Budget", style: TextStyle(color: Colors.white, fontSize: 16)),
          Text("\$${budget.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Total Spent: \$${totalSpent.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            isOverBudget ? "Over Budget by \$${remainingBalance.abs().toStringAsFixed(2)}" : "Remaining: \$${remainingBalance.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseList() {
    return Expanded(
      child: expenses.isEmpty
          ? const Center(child: Text("No expenses yet!", style: TextStyle(fontSize: 18)))
          : ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return ExpenseTile(expense: expense, onDelete: _deleteExpense);
        },
      ),
    );
  }
}