import 'package:firebase_login/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LOGGED IN SCREEN",
          style: TextStyle(color: Colors.white70, fontSize: 28),
        ),
        elevation: 0.0,
        backgroundColor: Colors.yellow[700],
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text(
              "Log out",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(80),
        alignment: Alignment.center,
        child: Column(
          children: [
            Image(
              image: AssetImage('images/mello.png'),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
              child: Text(
                "You have successfully logged in!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.yellow[700],
    );
  }
}
