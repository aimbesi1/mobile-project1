import 'package:flutter/material.dart';
import 'package:project1/CardSetsScreen.dart';
import 'package:project1/cardsview.dart';
import 'package:project1/database_helper.dart';
import 'package:project1/cardpanel.dart';
import 'package:project1/flashcard.dart';
import 'package:project1/theme_provider.dart';
import 'package:provider/provider.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: themeProvider.currentTheme,
          home: CardSetsPage(),
        );
      },
    );
  }
}

