import 'package:assyifa_admin/models/user_model.dart';
import 'package:assyifa_admin/views/navigations/call_center/call_center.dart';
import 'package:assyifa_admin/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentAuth = FirebaseAuth.instance;

    final String adminUid = 'OT9j91hxBDNY2ylxtObFSyJZE2H3';
    final user = Provider.of<UserModel>(context);
    print('user: $user');

    // return either Home or Authenticate Widget
    if (user == null) {
      return Login();
    } else {
      if (user.uid != adminUid) {
        _currentAuth.signOut();
        return Login();
      }
      else return CallCenter();
    }
  }
}
