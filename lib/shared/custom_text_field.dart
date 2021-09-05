import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String _label;
  final TextInputType _inputType;
  final TextEditingController _controller;
  final Function _validator;

  const CustomTextField(this._label, this._inputType, this._controller, this._validator);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  @override
  Widget build(BuildContext context) {
    TextInputFormatter textInputFormatter;
    if (widget._inputType == TextInputType.number) textInputFormatter = FilteringTextInputFormatter.digitsOnly;
    else textInputFormatter = FilteringTextInputFormatter.singleLineFormatter;

    return TextFormField(
      controller: widget._controller,
      keyboardType: widget._inputType,
      validator: widget._validator,
      inputFormatters: [
        textInputFormatter
      ],
      decoration: InputDecoration(
        labelText: widget._label,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF39A2DB), width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}