import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Object based on FirebaseUser
  MyUser _fbUser(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser> get checkUser {
    return _auth.authStateChanges().map(_fbUser);
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
