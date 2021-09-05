import 'package:assyifa_admin/services/auth.dart';
import 'package:assyifa_admin/shared/custom_button.dart';
import 'package:assyifa_admin/shared/custom_dialog.dart';
import 'package:assyifa_admin/shared/custom_password_text_field.dart';
import 'package:assyifa_admin/shared/custom_text_field.dart';
import 'package:assyifa_admin/shared/loading.dart';
import 'package:assyifa_admin/views/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {

  static const lightBlue = const Color(0xFFD0F3FC);
  static const mediumBlue = const Color(0xFF39A2DB);
  static const darkGray = const Color(0xFF707070);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final String adminUid = 'OT9j91hxBDNY2ylxtObFSyJZE2H3';

  String _emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Email tidak valid';
    else
      return null;
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Loading() : Scaffold(
        backgroundColor: Login.lightBlue,
        body: SafeArea(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/welcome_vector.png',
                width: double.infinity,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 35.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0))),
                  child: Form(
                    key: _formKey,
                    child: Wrap(
                      children: [
                        CustomTextField('Email', TextInputType.emailAddress, _emailController, _emailValidator),
                        SizedBox(width: double.infinity, height: 15.0),
                        CustomPasswordTextField('Password', _passwordController),
                        SizedBox(width: double.infinity, height: 15.0),
                        CustomButton(
                          'Masuk',
                              () {
                            signInWithEmailAndPassword(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }

  void signInWithEmailAndPassword(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);
      try {
        FirebaseUser result = await _auth.signInWithEmailAndPassword(email, password);
        print(result.toString());
        if (result == null) {
          setState(() {
            showErrorDialog('User tidak valid');
            _isLoading = false;
          });
        } else {
          print(result.uid);
          print(adminUid);
          if (result.uid != adminUid) {
            showErrorDialog('User tidak valid');
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Wrapper()));
          }
        }
      } catch (err) {
        print(err);
        setState(() {
          showErrorDialog('Terjadi error saat login');
          _isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Wrapper()));
      }
    }
  }

  void showErrorDialog(String error) {
    showDialog(context: context, builder: (context) {
      return CustomDialog(title: 'Error', content: error);
    });
  }
}