import 'package:assyifa_admin/services/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  final _currentAuth = FirebaseAuth.instance;
  String _email = 'Email';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _drawerHeader(),
          _drawerItem(
              icon: Icons.call,
              text: 'Call Center',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.callCenter)),
          _drawerItem(
              icon: Icons.logout,
              text: 'Keluar',
              onTap: () async {
                await _currentAuth.signOut();
              }
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserEmail();
  }

  void getUserEmail() async {
    await _currentAuth.currentUser().then((value) {
      setState(() {
        _email = value.email;
      });
    });
  }

  Widget _drawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text('As-Syifa Admin'),
      accountEmail: Text(_email),
    );
  }

  Widget _drawerItem({IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );

  }
}