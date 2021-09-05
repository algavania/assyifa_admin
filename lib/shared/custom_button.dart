import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String _text;
  final Function _action;

  const CustomButton(this._text, this._action);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _action,
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        minimumSize: Size(double.infinity, 40.0),
      ),
      child: Text(_text, style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }
}