import 'package:flutter/material.dart';
import 'package:flutter_project/shared/decorations.dart';
import 'package:flutter_project/shared/loading.dart';
import 'package:flutter_project/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/models/user.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  int selectedRadio;
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _phoenNum;
  String _location;
  int _userType;

  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
                key: _formKey,
                backgroundColor: Colors.red[300],
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.red[500],
                  elevation: 1.0,
                  title: Text('INFO'),
                  leading: Container(),
                ),
                body: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Form(
                        child: Column(children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textDecoration.copyWith(hintText: 'Name/Shop Name'),
                        validator: (val) =>
                            val.isEmpty ? 'Please enter a name' : null,
                        onChanged: (val) => setState(() => _name = val),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textDecoration.copyWith(hintText: 'Phone Number'),
                        validator: (val) =>
                            val.isEmpty ? 'Please enter a name' : null,
                        onChanged: (val) => setState(() => _phoenNum = val),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textDecoration.copyWith(
                            hintText: 'Address/Shop Adress'),
                        validator: (val) =>
                            val.isEmpty ? 'Please enter a name' : null,
                        onChanged: (val) => setState(() => _location = val),
                      ),
                      SizedBox(height: 20.0),
                      RadioListTile(
                        value: 1,
                        groupValue: selectedRadio,
                        tileColor: Colors.white,
                        title: Text('Owner'),
                        activeColor: Colors.white,
                        onChanged: (val) {
                          print('Radio $val');
                          setSelectedRadio(val);
                        },
                      ),
                      RadioListTile(
                        value: 2,
                        groupValue: selectedRadio,
                        tileColor: Colors.white,
                        title: Text('Customer'),
                        activeColor: Colors.white,
                        onChanged: (val) {
                          print('Radio $val');
                          setSelectedRadio(val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.red)),
                          color: Colors.red[800],
                          child: Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await DatabaseService(uid: user.uid)
                                  .updateUserData(
                                      _name ?? userData.name,
                                      _phoenNum ?? userData.phoneNum,
                                      _location ?? userData.address,
                                      _userType ?? userData.userType);
                              Navigator.pop(context);
                            }
                          })
                    ]))));
          } else {
            return Text('error');
          }
        });
  }
}
