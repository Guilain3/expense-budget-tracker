import 'package:hive/hive.dart';

part 'expense.g.dart'; 

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  String id; // Unique identifier

  @HiveField(1)
  String category;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String note; // Optional notes for expense

  Expense({required this.id, required this.category, required this.amount, required this.date, this.note = ''});
}
