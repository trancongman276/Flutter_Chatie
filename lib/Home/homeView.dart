import 'package:flutter/material.dart';

class homeView extends StatefulWidget {

  @override
  _homeViewState createState() => _homeViewState();
}

class _homeViewState extends State<homeView> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(onTap: (){print('pressed');},child: Icon(Icons.menu),),
            Text('Chatie'),
            GestureDetector(onTap: (){print('pressed');},child: Icon(Icons.add),),
          ],
        ),
      ),
      body: ListView(),
    );
  }
}
