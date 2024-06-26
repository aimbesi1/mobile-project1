import 'package:flutter/material.dart';
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
      home: const CardsView(title: 'View Flash Cards'),
    );
  }
}

class CardsView extends StatefulWidget {
  const CardsView({super.key, required this.title});

  final String title;

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  int _cardCount = 0;
  List<FlashCard> _cards = [];

  @override
  void initState() {
    super.initState();
    setCardData();
  }

  Future<void> setCardData() async {
    final cardCount = await dbHelper.queryCardCount(1);
    final cards = await dbHelper.queryAllCardsOfSet(1);

    setState(() {
      _cardCount = cardCount;
      _cards = cards;
    });
  }

  void addCard() async {
    await dbHelper.insertCard(
        FlashCard(front: "front text", back: "back text", setId: 1), 1);
    await setCardData();
    setState(() {});
  }

  void addSet() async {
    Map<String, dynamic> row = {DatabaseHelper.columnSetName: 'Bob'};
    await dbHelper.insertCardSet(row);
  }

  void querySets() async {
    final sets = await dbHelper.queryAllSets();
    debugPrint('query all sets:');
    for (final row in sets) {
      debugPrint(row.toString());
    }
  }

  void queryCards() async {
    // final cards = await dbHelper.queryAllCardsOfSet(1);
    debugPrint('query all cards:');
    for (final row in _cards) {
      debugPrint(row.toString());
    }
  }

  void printTables() async {
    await dbHelper.printTables();
  }

  void deleteTables() async {
    await dbHelper.printTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(children: [
        Expanded(
          child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(_cardCount, (index) {
                return Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(8.0),
                    child: CardPanel(card: _cards[index]));
              })),
        ),
        SizedBox(
            height: 50,
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: addCard, child: const Text('Add card')),
                ElevatedButton(onPressed: addSet, child: const Text('Add set')),
                ElevatedButton(
                    onPressed: querySets, child: const Text('Show sets')),
              ],
            )),
        SizedBox(
            height: 50,
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: queryCards,
                    child: const Text('Show cards in set 1')),
                ElevatedButton(
                    onPressed: printTables, child: const Text('Show tables')),
              ],
            )),
      ])),
    );
  }
}
