// Can launch the default browser
// Needed to make things look pretty
import 'package:flutter/material.dart';

// Needed to make things look pretty
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

// My lovely code for campaigns
import 'campaign.dart';

// My lovely code for characters
import 'character.dart';
import 'homebrew.dart';
import 'localPlay.dart';

class DigitalTableTopHome extends StatefulWidget {
  final String title;

  DigitalTableTopHome({Key key, this.title}) : super(key: key);

  @override
  _DigitalTableTopHome createState() => _DigitalTableTopHome();
}

class _DigitalTableTopHome extends State<DigitalTableTopHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Wrap(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  mainButton(context, 'Characters', () {navigateTo(context, PlayerCharacters());}),
                  mainButton(context, 'Campaign', () {navigateTo(context, Campaign());}),
                  mainButton(context, 'Local Play', () {navigateTo(context, LocalPlay());}),
                  mainButton(context, 'Homebrew', () {navigateTo(context, Homebrew());}),
                  mainButton(context, 'Donate a Kofi', () {donateAKofi();}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Null donateAKofi() {
  const url = 'https://ko-fi.com/johnthefourth';
  canLaunch(url).then((data) {
    if (data == true) {
      return launch(url);
    } else {
      throw 'Could not launch $url';
    }
  });
}

Null navigateTo(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return page;
  }));
}

FlatButton mainButton(BuildContext context, String text, Function func) {
  return FlatButton(
    color: Theme.of(context).accentColor,
    onPressed: () {
      func();
    },
    child: SizedBox(
      height: 40,
      width: 200,
      child: Center(
        child: Text(text),
      ),
    ),
  );
}
