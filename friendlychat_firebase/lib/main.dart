import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;

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
  final reference = FirebaseDatabase.instance.reference().child('messages');

  Future<Null> _ensureLoggedIn() async {
    var currentUser = googleSignIn.currentUser;
    if (currentUser == null) currentUser = await googleSignIn.signInSilently();
    if (currentUser == null) {
      currentUser = await googleSignIn.signIn();
      analytics.logLogin();
    }
    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Friendly Chat')),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
              query: reference,
              sort: (a, b) => b.key.compareTo(a.key),
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder:
                  (_, DataSnapshot snapshot, Animation<double> animation) {
                return new ChatMessage(
                    snapshot: snapshot, animation: animation);
              },
            ),
          ),
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
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Row(children: <Widget>[
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.photo_camera),
                onPressed: () async {
                  await _ensureLoggedIn();
                  File imageFile = await ImagePicker.pickImage();
                  int random = new Random().nextInt(100000);
                  StorageReference ref =
                      FirebaseStorage.instance.ref().child("image_$random.jpg");
                  StorageUploadTask uploadTask = ref.put(imageFile);
                  Uri downloadUrl = (await uploadTask.future).downloadUrl;
                  _sendMessage(imageUrl: downloadUrl.toString());
                }),
          ),
          new Flexible(
              child: new TextField(
            controller: _textEditingController,
            decoration:
                new InputDecoration.collapsed(hintText: 'Input text here'),
            onSubmitted: _handleTextSubmitted,
            onChanged: enableSendButton,
          )),
          new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _isComposing
                      ? _handleTextSubmitted(_textEditingController.text)
                      : null))
        ]),
      ),
    );
  }

  _handleTextSubmitted(String text) async {
    _textEditingController.clear();
    setState(() => _isComposing = false);

    await _ensureLoggedIn();
    _sendMessage(text: text);
  }

  void _sendMessage({String text, String imageUrl}) {
    reference.push().set({
      'text': text,
      'imageUrl': imageUrl,
      'senderName': googleSignIn.currentUser.displayName,
      'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
    });
    analytics.logEvent(name: 'send_message');
  }

  void enableSendButton(String text) {
    setState(() => _isComposing = text.length > 0);
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.snapshot, this.animation});
  final DataSnapshot snapshot;
  final Animation animation;
//  static const String _name = 'EdSigma';

  @override
  Widget build(BuildContext context) => new SizeTransition(
        sizeFactor:
            new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: new Container(
          margin: new EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(
                  backgroundImage:
                      new NetworkImage(snapshot.value['senderPhotoUrl']),
                ),
              ),
              new Expanded(
                  //Add Expanded to allow text to be wrapped to new line.
                  child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    snapshot.value['senderName'],
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  new Container(
                    margin: new EdgeInsets.only(top: 5.0),
                    child: snapshot.value['imageUrl'] != null
                        ? new Image.network(
                            snapshot.value['imageUrl'],
                            width: 250.0,
                          )
                        : new Text(snapshot.value['text']),
                  )
                ],
              ))
            ],
          ),
        ),
      );
}
