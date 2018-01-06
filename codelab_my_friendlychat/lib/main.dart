import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

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
  final List<ChatMessage> _messages = <ChatMessage>[];

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

    var chatMessage = new ChatMessage(text: text);
    print(chatMessage);
    setState(() => _messages.insert(0, chatMessage));
  }

  void enableSendButton(String text) {
    setState(() => _isComposing = text.length > 0);
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({@required this.text});

  final String text;
  static const String _name = 'EdSigma';

  @override
  Widget build(BuildContext context) =>
      new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(
              child: new Text(_name[0]),
            ),
          ),
          new Expanded(
            //Add Expanded to allow text to be wrapped to new line.
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    _name,
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead,
                  ),
                  new Container(
                    margin: new EdgeInsets.only(top: 5.0),
                    child: new Text("message"),
                  )
                ],
              ))
        ],
      );
}
