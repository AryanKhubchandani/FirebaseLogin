import 'package:firebase_login/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logged In Screen"),
        backgroundColor: Colors.black54,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text("Log out"),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(80),
          alignment: Alignment.center,
          child: Text(
            "You have successfully logged in!",
            style: TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          )),
      backgroundColor: Colors.pink[50],
    );
  }
}
