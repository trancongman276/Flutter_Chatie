import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class findView extends StatefulWidget {
  final String uid;

  const findView({Key key, @required this.uid}) : super(key: key);

  @override
  _findViewState createState() => _findViewState(uid);
}

class _findViewState extends State<findView> {
  final String uid;
  final TextEditingController _searchController = TextEditingController();
  String _searchList = '';
  var _selectedSearch;

  _findViewState(this.uid){
    print(uid);
  }

  void search() {
    print(_searchController.text);
    FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: _searchController.text)
        .get()
        .then((value) {
      print(value.docs[0].data()['Name']);
      setState(() {
        _selectedSearch = value.docs[0];
        _searchList = value.docs[0].data()['Name'];
      });
    });
  }

  Future<void> select() async {
    String id = _selectedSearch.id;
    String name = _selectedSearch.data()['Name'];
    String roomId;
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('Messages')
        .add({});
    roomId = docRef.id;
    print('RoomID $roomId');
    print('UID $uid');
    print('Friend ID $id');
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Friends')
        .doc(id)
        .set({
      'Name': name,
      'RoomId': roomId,
      'LastMessage':'',
    });

    FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .collection('Friends')
        .doc(uid)
        .set({
      'Name': name,
      'RoomId': roomId,
      'LastMessage':'',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              width: 250,
              // height: 30,
              child: TextField(
                controller: _searchController,
                autofocus: false,
                maxLines: 1,
                // maxLength: 20,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white70,
                decoration: InputDecoration.collapsed(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                search();
              },
              child: Icon(Icons.search),
            )
          ],
        ),
      ),
      body: FlatButton(
        child: Text(_searchList),
        onPressed: () {select();},
      ),
    );
  }
}
