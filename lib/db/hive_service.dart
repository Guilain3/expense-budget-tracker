import 'package:hive/hive.dart';
import '../models/expense.dart';

class HiveService {
  static const String _expenseBox = "expenses";
  static const String _settingsBox = "settings";

  // Open the expense box
  static Future<void> init() async {
    Hive.registerAdapter(ExpenseAdapter());
    await Hive.openBox<Expense>(_expenseBox);
    await Hive.openBox(_settingsBox);
  }
  // Budget Management
  static void setBudget(double budget) {
    final box = Hive.box(_settingsBox);
    box.put("monthly_budget", budget);
  }

  static double getBudget() {
    final box = Hive.box(_settingsBox);
    return box.get("monthly_budget", defaultValue: 0.0);
  }

  // Add expense
  static Future<void> addExpense(Expense expense) async {
    final box = Hive.box<Expense>(_expenseBox);
    await box.put(expense.id, expense);
  }

  // Get all expenses
  static List<Expense> getExpenses() {
    final box = Hive.box<Expense>(_expenseBox);
    return box.values.toList();
  }

  // Delete expense
  static Future<void> deleteExpense(String id) async {
    final box = Hive.box<Expense>(_expenseBox);
    await box.delete(id);
  }
}
