import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class registerView extends StatefulWidget {
  @override
  _registerViewState createState() => _registerViewState();
}

class _registerViewState extends State<registerView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _passwordControler = TextEditingController();
  final TextEditingController _nameControler = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  void dispose() {
    _emailControler.dispose();
    _passwordControler.dispose();
    _nameControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _success = true;
    String ex = '';
    String validateEmail(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Enter Valid Email';
      else
        return null;
    }

    String validatePassword(String value) {
      if (value.length < 6)
        return 'Password length must greater than 6';
      else
        return null;
    }

    void register() async {
      try {
        final UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _emailControler.text, password: _passwordControler.text);
        print(user.user);
        users.doc(user.user.uid).set({
          'Email': _emailControler.text,
          'Phone': '',
          'Name': _nameControler.text,
          'Role': 'user'
        });
        Navigator.pop(context);
        _formKey.currentState.reset();
      } catch (e) {
        setState(() {
          _success = false;
          ex = e.code;
        });
      }
    }

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('REGISTER'),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _nameControler,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (String value) {
                if (value.isEmpty) return 'Please fill the empty form.';
                return null;
              },
            ),
            TextFormField(
              controller: _emailControler,
              decoration: InputDecoration(labelText: 'Email'),
              validator: validateEmail,
            ),
            TextFormField(
              obscureText: true,
              controller: _passwordControler,
              decoration: InputDecoration(labelText: 'Password'),
              validator: validatePassword,
            ),
            RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) register();
                },
                child: Text('Register')),
            Container(
              child: Text(
                _success ? '' : ex,
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}
