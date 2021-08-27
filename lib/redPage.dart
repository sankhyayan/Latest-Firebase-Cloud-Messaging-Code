import 'package:flutter/material.dart';

class RedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text(
          "This is the red page",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
