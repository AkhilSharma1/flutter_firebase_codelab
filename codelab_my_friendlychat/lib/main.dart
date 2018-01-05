import 'package:flutter/material.dart';

void main() => runApp(new FriendlyChat());

class FriendlyChat extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Friendly Chat',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  TextEditingController _textEditingController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Friendly Chat')),
      body: new Column(
        children: <Widget>[
          new Expanded(child: new Center(child: new Text('Show List Here'))),
          new Divider(
            height: 1.0,
          ),
          new Container(child: _buildTextComposer())
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return new Container(
      margin: new EdgeInsets.symmetric(horizontal: 8.0),
      child: new IconTheme(
        data: new IconThemeData(color: Theme
            .of(context)
            .accentColor),
        child: new Row(children: <Widget>[
          new Flexible(
              child: new TextField(
                controller: _textEditingController,
                decoration:
                new InputDecoration.collapsed(hintText: 'Enter text here'),
                onSubmitted: _handleTextSubmitted,
                onChanged: enableSendButton,
              )),
          new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () =>
                  _isComposing
                      ? _handleTextSubmitted(_textEditingController.text)
                      : null))
        ]),
      ),
    );
  }

  void _handleTextSubmitted(String text) {
    _textEditingController.clear();
    setState(() => _isComposing = false);
  }

  void enableSendButton(String text) {
    setState(() => _isComposing = text.length > 0);
  }
}
