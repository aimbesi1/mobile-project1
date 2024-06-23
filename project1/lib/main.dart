import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: const Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Consider the following flash card...',
              ),
              SizedBox(width: 100, height: 100, child: FlashCard())
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
