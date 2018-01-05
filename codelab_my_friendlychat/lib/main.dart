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
    return new Row(children: <Widget>[
      new Flexible(
          child: new TextField(
            controller: _textEditingController,
            decoration: new InputDecoration.collapsed(
                hintText: 'Enter text here'),
            onSubmitted: _handleTextSubmitted,
          )),
      new IconButton(
          icon: new Icon(Icons.send),
          onPressed: () => _handleTextSubmitted(_textEditingController.text))
    ]);
  }


  void _handleTextSubmitted(String text) {
    print('submitted called');

  }
}
