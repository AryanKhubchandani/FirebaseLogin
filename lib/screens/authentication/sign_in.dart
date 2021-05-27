import 'package:firebase_login/screens/authentication/sign_in_using_no.dart';
import 'package:firebase_login/screens/home/home.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_login/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[700],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        elevation: 0.0,
        title: Text('Sign In'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(50, 20, 50, 5),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 40.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Email",
                ),
                validator: (val) => val.isEmpty ? "Enter an Email" : null,
                onChanged: (val) {
                  setState(() => email = val.trim());
                },
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Password",
                ),
                obscureText: true,
                validator: (val) => val.length < 6
                    ? "Password should be more than 6 characters"
                    : null,
                onChanged: (val) {
                  setState(() => password = val.trim());
                },
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 50.0),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 200, height: 50),
                child: ElevatedButton(
                  child: Text(
                    " Sign In",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.signInEnP(email, password);
                      if (result == null) {
                        setState(() => error =
                            "Please check whether you are using correct credentials");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow[700],
                    side: BorderSide(color: Colors.yellow[900], width: 2),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Text("-OR-"),
              SizedBox(height: 20.0),
              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  await _auth.signInGoogle().then((userCredential) => {
                        setState(() => {userCredential})
                      });
                },
              ),
              SizedBox(height: 10.0),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 220, height: 40),
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text("Sign In using Number",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignInNo()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow[700],
                    side: BorderSide(color: Colors.yellow[900], width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 20.0),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton.icon(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      widget.toggleView();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
