import 'package:flutter/material.dart';

class FlashCard extends StatefulWidget {
  const FlashCard({super.key});

  @override
  State<FlashCard> createState() => _FlashCardState();
}

// A flash card that can be flipped when the user taps on it.
// To determine its dimensions, put it inside a parent container with the width and height you want.
class _FlashCardState extends State<FlashCard> {
  String frontText = 'Front text';
  String backText = 'Back text';
  bool frontFacing = true;

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
