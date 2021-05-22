import 'package:firebase_login/screens/authentication.dart';
import 'package:firebase_login/screens/home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return either Home or Authentication
    return Authentication();
  }
}
