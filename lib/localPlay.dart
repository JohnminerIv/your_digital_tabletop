import 'package:flutter/material.dart';

class LocalPlay extends StatefulWidget {
  final String title = 'Local Play';

  @override
  _LocalPlay createState() => _LocalPlay();
}

class _LocalPlay extends State<LocalPlay> {
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

