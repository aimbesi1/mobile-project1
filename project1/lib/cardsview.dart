import 'package:flutter/material.dart';
import 'package:project1/database_helper.dart';
import 'package:project1/cardpanel.dart';
import 'package:project1/flashcard.dart';
import 'package:project1/main.dart';
import 'package:project1/quiz.dart';


class CardsView extends StatefulWidget {
  const CardsView({super.key, required this.setName, required this.setId});

  final String setName;
  final int setId;

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  int _cardCount = 0;
  List<FlashCard> _cards = [];
  TextEditingController _editTextController = TextEditingController();
  TextEditingController _frontTextController = TextEditingController();
  TextEditingController _backTextController = TextEditingController();


  @override
  void initState() {
    super.initState();
    setCardData();
  }

  Future<void> setCardData() async {
    final cardCount = await dbHelper.queryCardCount(widget.setId);
    final cards = await dbHelper.queryAllCardsOfSet(widget.setId);

    setState(() {
      _cardCount = cardCount;
      _cards = cards;
    });
  }

  void addCardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Enter Card Details", textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _frontTextController,
                    decoration: const InputDecoration(
                      hintText: 'Front Text',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _backTextController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Back Text',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                  ),
                ],
              ),
            ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _frontTextController.clear();
                    _backTextController.clear();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      String frontText = _frontTextController.text;
                      String backText = _backTextController.text;
                      if (frontText.isNotEmpty && backText.isNotEmpty) {
                        addCard(frontText, backText);
                      }
                      _frontTextController.clear();
                      _backTextController.clear();
                      Navigator.of(context).pop();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add'),
                ),
              ]
            )
          ]
        );
      },
    );
  }

  void addCard(String frontText, String backText) async {
    await dbHelper.insertCard(
        FlashCard(front: frontText, back: backText, setId: widget.setId), widget.setId);
    await setCardData();
    setState(() {});
  }

  // void addSet() async {
  //   Map<String, dynamic> row = {DatabaseHelper.columnSetName: 'Bob'};
  //   await dbHelper.insertCardSet(row);
  // }

  void querySets() async {
    final sets = await dbHelper.queryAllSets();
    debugPrint('query all sets:');
    for (final row in sets) {
      debugPrint(row.toString());
    }
  }

  void queryCards() async {
    final cards = await dbHelper.queryAllCardsOfSet(6);
    debugPrint('query all cards:');
    for (final row in cards) {
      debugPrint(row.toString());
    }
  }

  void printTables() async {
    await dbHelper.printTables();
  }

  void deleteTables() async {
    await dbHelper.printTables();
  }

  void onDelete() async {
    await setCardData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.setName),
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
                    child: CardPanel(card: _cards[index], onDelete: onDelete, key: ValueKey(_cards[index].id))
                    );
              })),
        ),
        Container(
            color: Theme.of(context).colorScheme.inversePrimary,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: addCardDialog,
                    child: const Text('Add card')
                ),
                // ElevatedButton(onPressed: addSet, child: const Text('Add set')),
                // ElevatedButton(
                //     onPressed: querySets, child: const Text('Show sets')),
                ElevatedButton(
                  onPressed: () {
                    if (_cards.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Quiz(
                                    title: 'Quiz: ${widget.setName}',
                                    cards: _cards,
                                  )
                          )
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please add cards to the set before starting the quiz."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Go to Quiz')
                )
              ],
            )),
        // SizedBox(
        //     height: 50,
        //     child: Row(
        //       children: [
        //         ElevatedButton(
        //             onPressed: queryCards,
        //             child: Text('Show cards in set ${widget.setId}')),
        //         ElevatedButton(
        //             onPressed: printTables, child: const Text('Show tables')),
        //       ],
        //     )),
      ])),
    );
  }
}
