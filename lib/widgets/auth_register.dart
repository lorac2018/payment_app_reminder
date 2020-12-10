import 'package:flutter/material.dart';
import 'package:flutter_reminder_payment/widgets/text_register.dart';
import 'package:flutter_reminder_payment/widgets/user_old.dart';


class AuthRegister extends StatefulWidget {
  @override
  _AuthRegisterState createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
  final _data = GlobalKey<FormState>();
  var _userEmail = '';
  var _userPassword = '';

  void _submit() {
    final isValid = _data.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _data.currentState.save();
      print(_userEmail);
      print(_userPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromRGBO(28, 45, 62, 1),
            Color.fromRGBO(56, 90, 124, 1),
          ],
        ),
      ),
      child: ListView(children: <Widget>[
        Form(
          key: _data,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60, left: 10),
                    child: RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          'Payment' + '\n' + 'Reminder' + '\n' + 'App',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        )),
                  ),
                  TextRegister(),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color.fromRGBO(95, 122, 150, 1),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  onSaved: (value) {
                    _userEmail = value;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  onSaved: (value) {
                    _userPassword = value;
                  },
                ),
              ),
              //ButtonRegister(),
              Padding(
                padding: const EdgeInsets.only(top: 40, right: 50, left: 200),
                child: Container(
                  alignment: Alignment.bottomRight,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue[300],
                          blurRadius: 10.0,
                          // has the effect of softening the shadow
                          spreadRadius: 1.0,
                          // has the effect of extending the shadow
                          offset: Offset(
                            5.0, // horizontal, move right 10
                            5.0, // vertical, move down 10
                          ),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _submit();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Register',
                          style: TextStyle(
                            color: Color.fromRGBO(22, 36, 49, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              UserOld(),
            ],
          ),
        ),
      ]),
    ));
  }
}
