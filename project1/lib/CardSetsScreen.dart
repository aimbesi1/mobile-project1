import 'package:flutter/material.dart';
import 'package:project1/cardset.dart';
import 'package:project1/cardsview.dart';
import 'package:project1/main.dart';
import 'package:project1/settings_screen.dart';

class CardSetsPage extends StatefulWidget {
  @override
  _CardSetsPageState createState() => _CardSetsPageState();
}

class _CardSetsPageState extends State<CardSetsPage> {
  // Remove Test sets from list if you want the set page to start empty
  // List<String> _sets = ['Test Set 1', 'Test Set 2'];
  List<CardSet> _sets = [];
  TextEditingController _editTextController = TextEditingController();
  int _currentSetIndex = 0;

  //I went through and styled the colors of each button individually because I couldn't quite
  //figure out how to use a theme with the showDialogs

  @override
  void initState() {
    super.initState();
    updateSetData();
  }

  Future<void> updateSetData() async {
    final sets = await dbHelper.queryAllSets();

    setState(() {
      _sets = sets;
    });
  }

  Future<void> deleteSet(int id) async {
    await dbHelper.deleteSet(id);
    updateSetData();
  }

  Future<void> renameSet(int index, String name) async {
    _sets[index].name = name;
    await dbHelper.renameSet(_sets[index]);
    updateSetData();
  }

  Future<void> insertSet(CardSet set) async {
    await dbHelper.insertCardSet(set);
    updateSetData();
  }

  // Function for editing set name and deleting sets
  // User must hold down the set to edit or delete
  void _editSet(int index) {
    setState(() {
      _currentSetIndex = index;
      debugPrint('set index: $_currentSetIndex');
    });

    //Builds dialog box for editing or deleting sets
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Edit or Delete Set', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              //Text Field
              TextField(
                maxLength: 25,
                controller: _editTextController..text =_sets[index].name,
                // decoration: InputDecoration(
                //   hintText: _sets[index].name,
                // ),
              ),

              ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  //Edit Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if(_editTextController.text.isNotEmpty) {
                          renameSet(index, _editTextController.text);
                        }
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
                      deleteSet(_sets[index].id!);
                      setState(() {
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

  //Function for creating new sets
  void _addSet() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Enter Set Name', textAlign: TextAlign.center),
            content: TextField(
              maxLength: 25,
              controller: _editTextController,
              decoration: const InputDecoration(hintText: 'Set Name'),
            ),
            actions: <Widget>[

              //Cancel Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _editTextController.clear();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cancel'),
                  ),


                  //Add Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        String setName = _editTextController.text;
                        if (setName.isNotEmpty) {
                          // _sets.add(new CardSet(name: setName));
                          insertSet(CardSet(name: setName));
                        }
                        _editTextController.clear();
                        Navigator.of(context).pop();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Card Sets'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            // Example for clicking the settings button transition
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              //ListView.builder creates a scrollable list of items
              child: ListView.builder(
                itemCount: _sets.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    //Detects if user holds on card set or taps the card set
                    onLongPress: () {
                      _editSet(index);
                    },
                    onTap: () {
                      //Transition to cards screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CardsView(setName: _sets[index].name, setId: _sets[index].id!))
                      );
                    },
                    child: Card(
                      color: Theme.of(context).colorScheme.primary,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                        title: Text(
                          _sets[index].name,
                          style: const TextStyle(fontSize: 28.0, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            //GestureDetector for adding a set
            GestureDetector(
              onTap: _addSet,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                height: 100.0,
                child: Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: const Center(
                    child: Text(
                      'Add a Set',
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}