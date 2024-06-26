import 'package:flutter/material.dart';
import 'package:project1/flashcard.dart';

class CardPanel extends StatefulWidget {
  final FlashCard card;

  const CardPanel({super.key, required this.card});

  @override
  State<CardPanel> createState() => _CardPanelState();
}

// A flash card that can be flipped when the user taps on it.
// To determine its dimensions, put it inside a parent container with the width and height you want.
class _CardPanelState extends State<CardPanel> {
  String frontText = '';
  String backText = '';
  bool frontFacing = true;

  void init() {
    setState(() {
      frontText = widget.card.front;
      backText = widget.card.back;
    });
  }

  void flip() {
    setState(() {
      frontFacing = !frontFacing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            flip();
          });
        },
        child: frontFacing
            ? Container(
                color: Theme.of(context).colorScheme.primary,
                child: Center(
                    child: Text(frontText,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary))))
            : Container(
                color: Theme.of(context).colorScheme.secondary,
                child: Center(
                    child: Text(backText,
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSecondary)))));
  }
}
