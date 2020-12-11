import 'package:flutter/material.dart';
import 'package:flutter_reminder_payment/widgets/text_register.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _isLogin, context);
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
                  Color.fromRGBO(56, 90, 124, 1)
                ],
              ),
            ),
            child: ListView(children: [
              Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 60, left: 10),
                              child: RotatedBox(
                                  quarterTurns: -1,
                                  child: Text(
                                      'Payment' +
                                          '\n' +
                                          'Reminder' +
                                          '\n' +
                                          'App',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.w900))),
                            ),
                            TextRegister(),
                          ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(top: 50, left: 50, right: 50),
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
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
                              labelStyle: TextStyle(color: Colors.white70),
                            ),
                            onSaved: (value) {
                              _userEmail = value;
                            },
                          ),
                        ),
                        if (!_isLogin)
                          Container(
                            padding: const EdgeInsets.only(
                                top: 20, left: 50, right: 50),
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              key: ValueKey('username'),
                              validator: (value) {
                                if (value.isEmpty || value.length < 4) {
                                  return 'Please enter at least 4 characters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Username',
                                  border: InputBorder.none,
                                  fillColor: //Color.fromRGBO(95, 122, 150, 1),
                                      Colors.white,
                                  labelStyle: TextStyle(
                                    color: Colors.white70,
                                  )),
                              onSaved: (value) {
                                _userName = value;
                              },
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, left: 50, right: 50),
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            key: ValueKey('password'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 7) {
                                return 'Password must be at least 7 characters long.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: InputBorder.none,
                              fillColor: Color.fromRGBO(95, 122, 150, 1),
                              labelStyle: TextStyle(color: Colors.white70),
                            ),
                            obscureText: true,
                            onSaved: (value) {
                              _userPassword = value;
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                        if (widget.isLoading) CircularProgressIndicator(),
                        if (!widget.isLoading)
                          RaisedButton(
                            child: Text(
                              _isLogin ? 'Sign In' : 'Signup',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Quicksand'),
                            ),
                            onPressed: _trySubmit,
                          ),
                        if (!widget.isLoading) Container(height: 20),
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                              _isLogin
                                  ? 'Create new account'
                                  : 'I already have an account',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Quicksand')),
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                        )
                      ]))
            ])));
  }
}
