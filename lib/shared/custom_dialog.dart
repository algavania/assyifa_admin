import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  static const Color red = Color(0xFFFF4F4F);

  const CustomDialog({Key key, this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 40.0),
          margin: EdgeInsets.only(top: 35.0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.0),
              Text(
                content,
                style: TextStyle(fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48.0),
                      primary: red,
                      elevation: 0.0),
                  child: Text(
                    'Tutup',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
        Positioned(
          left: 5.0,
          right: 5.0,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                child: Icon(
                  Icons.warning_rounded,
                  color: red,
                  size: 50.0,
                )),
          ),
        ),
      ],
    );
  }
}
