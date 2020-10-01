import 'package:chatie/Home/findView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class homeView extends StatefulWidget {
  final String uid;

  homeView({Key key, @required this.uid}) : super(key: key);

  @override
  _homeViewState createState() => _homeViewState(uid);
}

class _homeViewState extends State<homeView> {
  final String uid;
  ScaffoldState _scaffoldState;
  DocumentReference user;

  _homeViewState(this.uid) {

    user = FirebaseFirestore.instance.collection('Users').doc(uid);
  }

  void showSnackBar() => _scaffoldState.showSnackBar(SnackBar(
        content: Text('Welcome $uid'),
        duration: Duration(seconds: 3),
      ));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showSnackBar());
  }

  // Future getFriendList() async {
  //   var result = await user.get();
  // }

  @override
  Widget build(BuildContext context) {
    Widget _buildItem(
        BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      print(snapshot.data.docs);
      print(uid);
      return ListView(
        children: snapshot.data.docs.map((DocumentSnapshot document) {
          return FlatButton(
            onPressed: (){
              print('Hello');
            },
            child: Text(document.id.toString(),),
          );
        }).toList(),
        itemExtent: 80.0,
        padding: EdgeInsets.all(20),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print('pressed');
              },
              child: Icon(Icons.menu),
            ),
            Text('Chatie'),
            GestureDetector(
              onTap: () {
                print('pressed');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => findView(uid: uid,)));
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
      body: Builder(builder: (BuildContext buildContext) {
        _scaffoldState = Scaffold.of(buildContext);
        return Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .collection('Friends')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                );
              else
                return _buildItem(context, snapshot);
            },
          ),
        );
      }),
    );
  }
}

class Friends {
  String name;
  String lastMessage;

  Friends({this.name, this.lastMessage});
}
