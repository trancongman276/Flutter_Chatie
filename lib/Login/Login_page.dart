import 'package:chatie/Home/homeView.dart';
import 'package:chatie/Login/registerView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class loginView extends StatefulWidget {
  @override
  _loginViewState createState() => _loginViewState();
}

class _loginViewState extends State<loginView> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Map<String, dynamic> _formData = {'email': null, 'password': null};
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _passwordControler = TextEditingController();
  bool _success;

  @override
  void dispose() {
    _emailControler.dispose();
    _passwordControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      if (value.length < 6) {
        return 'Wrong password format';
      }
      return '';
    }

    Widget textField(bool isPassword) {
      return TextFormField(
        controller: isPassword ? _passwordControler : _emailControler,
        onSaved: (String value) {
          isPassword
              ? _formData['password'] = value
              : _formData['email'] = value;
        },
        validator: isPassword ? validatePassword : validateEmail,
        keyboardType: !isPassword ? TextInputType.emailAddress : null,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: isPassword ? 'Password' : 'Email',
        ),
      );
    }

    void login() async {
      try {
        final UserCredential user = await _auth.signInWithEmailAndPassword(
            email: _emailControler.text, password: _passwordControler.text);
        print('Login $user.uid');
        Navigator.push(context,MaterialPageRoute(builder: (context) => homeView(uid : user.user.uid)));
      } catch (e) {
        print('Error $e.code');
        setState(() {
          _success = false;
        });
      }
    }

    void register() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => registerView()),
      );
    }

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              textField(false),
              textField(true),
              RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      print('Submited');
                      print(_formData);
                      login();
                    }
                  },
                  child: Text('Login')),
              RaisedButton(
                onPressed: () => register(),
                child: Text('Register'),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _success == null
                      ? ''
                      : (_success
                          ? 'Successfully signed in '
                          : 'Sign in failed'),
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ]),
      ),
    );
  }
}
