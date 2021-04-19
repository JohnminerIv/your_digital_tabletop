import 'package:flutter/material.dart';

class Homebrew extends StatefulWidget {
  final String title = 'Home Brew';

  @override
  _HomeBrew createState() => _HomeBrew();
}

class _HomeBrew extends State<Homebrew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Text('Nothing to see here...'),
    );
  }
}