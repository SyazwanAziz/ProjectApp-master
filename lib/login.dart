import 'package:flutter/material.dart';
import 'package:flutter_project/shared/decorations.dart';
import 'package:flutter_project/services/auth.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

final AuthService _auth = AuthService();
final _formKey = GlobalKey<FormState>();
String error = '';
bool loading = false;

// text field state
String email = '';
String password = '';

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[300],
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        elevation: 1.0,
        title: Text('LOG IN'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration: textDecoration.copyWith(hintText: 'Password'),
                validator: (val) =>
                    val.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.red)),
                  color: Colors.red[800],
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          loading = false;
                          error = 'Could not sign in with those credentials!';
                        });
                      }
                    }
                  }),
              Container(
                child: InkWell(
                    child: new Text('Click here to SIGN UP'),
                    onTap: () {
                      widget.toggleView();
                    }),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              )
            ]),
          )),
    );
  }
}
