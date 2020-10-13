import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  final String uid, roomId;

  const ChatView({Key key, @required this.uid, @required this.roomId})
      : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState(uid, roomId);
}

class _ChatViewState extends State<ChatView> {
  String uid, roomId;
  var db = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  _ChatViewState(String uid, String roomId) {
    this.uid = uid;
    this.roomId = roomId;
  }

  @override
  Widget build(BuildContext context) {
    void sendMessage() {
      if (_messageController.text.isNotEmpty) {
        db.collection('Messages').doc(roomId).collection('MessageList').add({
          'Message': _messageController.text,
          'Time': DateTime.now().microsecondsSinceEpoch,
          'uid': uid,
        });
        _messageController.clear();
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }

    Widget _buildList(
        BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      print(snapshot.data.docs.length);
      print(roomId);
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // controller: _scrollController,
        // padding: EdgeInsets.all(10),
        // shrinkWrap: true,
        // scrollDirection: Axis.vertical,
        children: snapshot.data.docs.map((DocumentSnapshot document) {
          print(document.data()['Message']);

          return Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              // width: 10,
              // decoration: BoxDecoration(
              //     border: Border(
              //         bottom: BorderSide()
              //     )),
              alignment: document.data()['uid'] == uid
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    document.data()['Message'],
                    style: TextStyle(color: Colors.white),
                  )));
        }).toList(),
      );
    }

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 50),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    StreamBuilder(
                      stream: db
                          .collection('Messages')
                          .doc(roomId)
                          .collection('MessageList')
                          .orderBy('Time')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                            ),
                          );
                        else
                          return _buildList(context, snapshot);
                      },
                    ),
                  ]),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 50,
                    // width: 200,
                    child: TextFormField(
                      onTap: () => _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent),
                      controller: _messageController,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: () => sendMessage(),
                    icon: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          // child:Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Expanded(
          //       child: Container(
          //         // width: 200,
          //         child: TextFormField(
          //           onTap: () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
          //           controller: _messageController,
          //           maxLines: 3,
          //           minLines: 1,
          //           decoration: InputDecoration(),
          //         ),
          //       ),
          //     ),
          //     Container(
          //       child: IconButton(
          //         onPressed: () => sendMessage(),
          //         icon: Icon(Icons.send),
          //       ),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}
