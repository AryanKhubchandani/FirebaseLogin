import 'package:firebase_login/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
        title: Text(
          'SIGN UP',
          style: TextStyle(color: Colors.white70, fontSize: 28),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(50, 10, 50, 5),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(
                    'images/logo.jpg',
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.yellow[800], width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.yellow[600], width: 2),
                  ),
                ),
                validator: (val) => val.isEmpty ? "Enter an email" : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.yellow[800], width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.yellow[600], width: 2),
                  ),
                ),
                obscureText: true,
                validator: (val) => val.length < 6
                    ? "Password should be more than 6 characters"
                    : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 50.0),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 200, height: 50),
                child: ElevatedButton(
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.registerEnP(email, password);
                      if (result == null) {
                        setState(() => error = "Enter a valid Email");
                      }
                    }
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
                    "Already have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton.icon(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Sign In",
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
