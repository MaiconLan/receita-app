import 'package:flutter/material.dart';

class Progress extends StatelessWidget {

  Progress({this.msg});

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Text(
            msg,
            style: TextStyle(
                color: Colors.deepOrangeAccent, fontSize: 25.0),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
