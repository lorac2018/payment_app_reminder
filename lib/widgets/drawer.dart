//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/homepage_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      _drawerHeader(),
      _createDrawerItem(
          icon: Icons.home,
          text: 'Homepage',
          onTap: () =>
              Navigator.pushReplacementNamed(context, HomePage.routeName)),
      _createDrawerItem(icon: Icons.history, text: 'History', onTap: () {}),
      _createDrawerItem(
          icon: Icons.exit_to_app,
          text: 'Logout',
          onTap: () {
            FirebaseAuth.instance.signOut();
          })
    ]));
  }

  Widget _drawerHeader() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    return DrawerHeader(
        decoration: BoxDecoration(color: Color.fromRGBO(56, 90, 124, 1)),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 5,
              left: 5,
              child: Text(
                  'Welcome' + '\n' + _auth.currentUser.displayName + '!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w500))),
        ]));
  }
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon, color: Color.fromRGBO(28, 45, 62, 1)),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            text,
            style: TextStyle(
                color: Color.fromRGBO(22, 36, 49, 1),
                fontSize: 15,
                fontFamily: 'Quicksand'),
          ),
        )
      ],
    ),
    onTap: onTap,
  );
}
