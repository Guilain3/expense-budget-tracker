import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'db/hive_service.dart';
import 'screens/home_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/budget_screen.dart';
import 'theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: AnimatedSplashScreen(
              splash: Icons.monetization_on,
              splashTransition: SplashTransition.fadeTransition,
              backgroundColor: Colors.blueAccent,
              nextScreen: HomeScreen(),
            ),
            initialRoute: '/',
            routes: {
              '/add_expense': (context) => AddExpenseScreen(),
              '/reports': (context) => ReportsScreen(),
              '/budget': (context) => BudgetScreen(),
            },
          );
        },
      ),
    );
  }
}