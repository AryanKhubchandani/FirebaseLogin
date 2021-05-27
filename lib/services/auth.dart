import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Object based on FirebaseUser
  MyUser fbUser(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser> get checkUser {
    return _auth.authStateChanges().map(fbUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return fbUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInEnP(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      User user = result.user;
      return fbUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in using google
  Future signInGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential googleResult =
          await _auth.signInWithCredential(googleAuthCredential);
      return googleResult;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register using email and password
  Future registerEnP(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      User user = result.user;
      return fbUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
