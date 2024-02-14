import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //Create new account using email password method
  Future<String> createAccountWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //Login with email password method
  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login Succesful";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //logout the user
  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  //Check if user is signed in or not
  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  // for login with google
  Future<String> continueWithgoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      //send auth request
      final GoogleSignInAuthentication gAuth = await googleUser!.authentication;

      //obtain a new credential
      final creds = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      //sign in with the credentials
      await FirebaseAuth.instance.signInWithCredential(creds);

      return "Google Login Succesful";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
}
