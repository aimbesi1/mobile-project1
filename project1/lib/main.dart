import 'package:flutter/material.dart';
import 'package:project1/CardSetsScreen.dart';
import 'package:project1/cardsview.dart';
import 'package:project1/database_helper.dart';
import 'package:project1/cardpanel.dart';
import 'package:project1/flashcard.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: CardsView(title: "View cards in set 1", setIndex: 1),
      home: CardSetsPage()
    );
  }
}

