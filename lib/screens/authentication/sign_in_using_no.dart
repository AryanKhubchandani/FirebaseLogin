import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/services/auth.dart';
import 'package:flutter/material.dart';

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
      showSnackbar("verification code: " + verificationId);
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
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          title: Text("Sign In using Number"),
          backgroundColor: Colors.brown,
        ),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8),
            // color: Colors.pink[50],
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                          labelText: 'Phone number (+xx xxx-xxx-xxxx)'),
                      validator: (value) {
                        if (value.isEmpty) {
                          showSnackbar("Enter valid Number");
                        }
                        return null;
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          child: Text("Verify Number"),
                          onPressed: () async {
                            verifyPhoneNumber();
                          }),
                    ),
                    TextFormField(
                      controller: _smsController,
                      decoration:
                          const InputDecoration(labelText: 'Verification code'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () async {
                            signInWithPhoneNumber();
                          },
                          child: Text("Sign in")),
                    ),
                  ],
                )),
          ),
        ));
  }
}
