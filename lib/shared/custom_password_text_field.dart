import 'package:flutter/material.dart';

class CustomPasswordTextField extends StatefulWidget {
  final String _label;
  final TextEditingController _controller;

  const CustomPasswordTextField(this._label, this._controller);

  @override
  _CustomPasswordTextFieldState createState() => _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._controller,
      obscureText: !_isShowPassword,
      enableSuggestions: false,
      autocorrect: false,
      validator: (value) => value.length < 6 ? 'Kurang lebih harus terdapat 6 karakter' : null,
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
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isShowPassword = !_isShowPassword;
            });
          },
          child: Icon(
            _isShowPassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }
}
