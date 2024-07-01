import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildThemeTile(context, 'Purple Theme', Colors.deepPurple),
          _buildThemeTile(context, 'Blue Theme', Colors.blue),
          _buildThemeTile(context, 'Green Theme', Colors.green),
          _buildThemeTile(context, 'Red Theme', Colors.red),
          _buildThemeTile(context, 'Orange Theme', Colors.orange),
          _buildThemeTile(context, 'Pink Theme', Colors.pink),
          _buildThemeTile(context, 'Yellow Theme', Colors.yellow),
          _buildThemeTile(context, 'Teal Theme', Colors.teal),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  Widget _buildThemeTile(BuildContext context, String title, Color color) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: color == Colors.yellow ? Colors.black : Colors.white),
      ),
      tileColor: color,
      onTap: () {
        Provider.of<ThemeProvider>(context, listen: false).setTheme(
          ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: color),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
