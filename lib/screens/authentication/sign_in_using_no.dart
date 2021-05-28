import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInNo extends StatefulWidget {
  final Function toggleView;
  SignInNo({this.toggleView});
  @override
  _SignInNoState createState() => _SignInNoState();
}

class _SignInNoState extends State<SignInNo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService authService = AuthService();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId;

  void showSnackbar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void verifyPhoneNumber() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      showSnackbar(
          "Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showSnackbar(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      showSnackbar('Please check your phone for the verification code.');
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackbar("Failed to Verify Phone Number: ${e}");
    }
  }

  Future signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user;
      return authService.fbUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[700],
      appBar: AppBar(
        title: Text(
          "SIGN IN USING NUMBER",
          style: TextStyle(color: Colors.white70, fontSize: 24),
        ),
        elevation: 0.0,
        backgroundColor: Colors.yellow[700],
      ),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(40, 30, 40, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Icon(
                    FontAwesomeIcons.phoneAlt,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
                SizedBox(height: 50.0),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone number (+xx xxx-xxx-xxxx)',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: Colors.yellow[800], width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: Colors.yellow[600], width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      showSnackbar("Enter valid Number");
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 180, height: 40),
                    child: ElevatedButton(
                      child: Text("Verify Number"),
                      onPressed: () async {
                        verifyPhoneNumber();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow[700],
                        side: BorderSide(color: Colors.yellow[900], width: 2),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                TextFormField(
                  controller: _smsController,
                  decoration: InputDecoration(
                    labelText: 'Verification code',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: Colors.yellow[800], width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: Colors.yellow[600], width: 2),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 50.0),
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 180, height: 40),
                    child: ElevatedButton(
                      onPressed: () async {
                        signInWithPhoneNumber();
                      },
                      child: Text("Sign in"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow[700],
                        side: BorderSide(color: Colors.yellow[900], width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
