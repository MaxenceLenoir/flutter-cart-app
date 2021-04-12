import 'package:flutter/material.dart';

class DonnesVides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text(
        "Aucune donnée n'est présente",
        textScaleFactor: 2.5,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontStyle: FontStyle.italic
        ),
      )
    );
  }
}