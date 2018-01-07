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

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  TextEditingController _textEditingController = new TextEditingController();
  bool _isComposing = false;
  final List<ChatMessage> _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Friendly Chat')),
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
                reverse: true,
                padding: new EdgeInsets.all(8.0),
              )),
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

    var chatMessage = new ChatMessage(
        text: text,
        animationController: new AnimationController(
            vsync: this, duration: new Duration(milliseconds: 200)));
    print(chatMessage);
    setState(() => _messages.insert(0, chatMessage));
    chatMessage.animationController.forward();
  }

  void enableSendButton(String text) {
    setState(() => _isComposing = text.length > 0);
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({@required this.text, @required this.animationController});

  final AnimationController animationController;
  final String text;
  static const String _name = 'EdSigma';

  @override
  Widget build(BuildContext context) =>
      new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeOut),
        child: new Container(
          margin: new EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
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
                        child: new Text(text),
                      )
                    ],
                  ))
            ],
          ),
        ),
      );
}
