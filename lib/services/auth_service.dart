import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get user => _auth.authStateChanges();

  Future<void> signInWithGoogle() async {
    try {
      developer.log('Attempting to sign in with Google', name: 'com.example.myapp.auth');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        developer.log('Google user signed in: ${googleUser.email}', name: 'com.example.myapp.auth');
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        developer.log('Successfully signed in with Google and Firebase', name: 'com.example.myapp.auth');
      } else {
        developer.log('Google sign in was cancelled by the user', name: 'com.example.myapp.auth');
      }
    } catch (e, s) {
       developer.log(
        'Error signing in with Google',
        name: 'com.example.myapp.auth',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
