import 'package:flutter/material.dart';
import 'package:project1/flashcard.dart';
import 'package:project1/main.dart';

class CardPanel extends StatefulWidget {
  FlashCard card;
  final bool canEdit;
  final VoidCallback? onDelete;

 CardPanel({Key? key, required this.card, this.onDelete, this.canEdit = true})
      : super(key: key ?? ValueKey(card.id));

  @override
  State<CardPanel> createState() => _CardPanelState();
}

// A flash card that can be flipped when the user taps on it.
// To determine its dimensions, put it inside a parent container with the width and height you want.
class _CardPanelState extends State<CardPanel> {
  
  String frontText = '';
  String backText = '';
  bool frontFacing = true;

  TextEditingController _editTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('received card: ${widget.card}');
    // setState(() {
      frontText = widget.card.front;
      backText = widget.card.back;
    // });
  }

  Future<void> updateText(String text) async {
    if (frontFacing) {
      widget.card.front = text;
    }
    else {
      widget.card.back = text;
    }
    await dbHelper.updateCard(widget.card);
    setState(() {
      frontText = widget.card.front;
      backText = widget.card.back;
    });
  }

  Future<void> deleteCard() async {
    await dbHelper.deleteCard(widget.card.id!);
    widget.onDelete!();
    // widget.card = await dbHelper.getCard(widget.card.id!);
    setState(() {
      frontFacing = true;
      frontText = widget.card.front;
      backText = widget.card.back;
    });
  }

  void flip() {
    setState(() {
      frontFacing = !frontFacing;
    });
  }

  void editCard() {
    //Builds dialog box for editing or deleting sets
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Edit or Delete Card', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              //Text Field
              TextField(
                maxLength: 100,
                controller: _editTextController..text = frontFacing ? frontText : backText,
                // decoration: InputDecoration(
                //   hintText: frontFacing ? frontText : backText,
                // ),
              ),

              ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  //Edit Button
                  ElevatedButton(
                    onPressed: () {
                      if(_editTextController.text.isNotEmpty) {
                          updateText(_editTextController.text);
                      }
                      setState(() {
                        _editTextController.clear();
                        Navigator.of(context).pop();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Edit'),
                  ),

                  //Delete Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        deleteCard();
                        _editTextController.clear();
                        Navigator.of(context).pop();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),

          actions: <Widget>[
            //Cancel Button
            ElevatedButton(
              onPressed: () {
                _editTextController.clear();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Center(
                child: Text('Cancel', textAlign: TextAlign.center),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            flip();
          });
        },
        onLongPress: () {
          if (widget.canEdit) {
            editCard();
          }
        },
        child: frontFacing
            ? Container(
                color: Theme.of(context).colorScheme.primary,
                child: Center(
                    child: Text(frontText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary))))
            : Container(
                color: Theme.of(context).colorScheme.tertiary,
                child: Center(
                    child: Text(backText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onTertiary)))));
  }
}