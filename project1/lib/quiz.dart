import 'package:flutter/material.dart';
import 'package:project1/database_helper.dart';
import 'package:project1/cardpanel.dart';
import 'package:project1/flashcard.dart';
import 'package:project1/main.dart';

class Quiz extends StatefulWidget {
  List<FlashCard> cards;
  String title;

  Quiz({super.key, required this.cards, required this.title});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late CardPanel currentPanel;
  int _currentIndex = 0;
  late int _cardCount;

  @override
  void initState() {
    _cardCount = widget.cards.length;
    shuffleCards();
    updatePanel();
    super.initState();
  }

  void updatePanel() {
    setState(() {
      currentPanel =
          CardPanel(card: widget.cards[_currentIndex], canEdit: false);
    });
  }

  void shuffleCards() {
    widget.cards.shuffle();
  }

  void nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _cardCount;
      updatePanel();
    });
  }

  void previousCard() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % _cardCount;
      updatePanel();
    });
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
        Container(
            padding: EdgeInsets.all(4),
            child: Text("${_currentIndex + 1} / $_cardCount")),
        Expanded(
            child: Container(
                // width: 100,
                height: 400,
                padding: const EdgeInsets.all(8.0),
                child: currentPanel)),
        SizedBox(
            height: 50,
            child: Row(
              children: [
                // ElevatedButton(onPressed: addSet, child: const Text('Add set')),
                ElevatedButton(
                    onPressed: previousCard, child: const Text('Previous')),
                ElevatedButton(onPressed: nextCard, child: const Text('Next')),
              ],
            )),
      ])),
    );
  }
}
