import 'package:flutter/material.dart';

class GreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text(
          "This is the green page",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
