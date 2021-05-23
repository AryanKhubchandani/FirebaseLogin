import 'package:firebase_login/screens/authentication/authentication.dart';
import 'package:firebase_login/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_login/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    // print(user);
    if (user == null) {
      return Authentication();
    } else {
      return Home();
    }
  }
}
