import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Object based on FirebaseUser
  Users _fbUser(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _fbUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // sign in with email and password

  // sign in using google

  // sign in using OTP

  // register using email and password

  // register using google

  // register using OTP

  // sign out

}
