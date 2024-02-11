import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

import 'package:talktime/main.dart';

class Auth {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> createUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final currentUser = FirebaseAuth.instance.currentUser;
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .set({
          "email": currentUser.email,
          "account_creation": DateTime.now(),
          "uid": currentUser.uid,
          "display_name": currentUser.displayName,
          "photo_url": currentUser.photoURL,
          "phone_number": currentUser.phoneNumber,
          "friend_list": List<DocumentReference>,
        });
      } on FirebaseException catch (e) {
        debugPrint(e);
      }
    }
  }

  Future<void> createUserCustom(email, uid, displayName, pfp, phoneNum) async {
    if (FirebaseAuth.instance.currentUser != null) {
      final currentUser = FirebaseAuth.instance.currentUser;
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .set({
          "email": currentUser.email,
          "account_creation": DateTime.now(),
          "uid": currentUser.uid,
          "display_name": currentUser.displayName,
          "username": currentUser.uid,
          "photo_url": currentUser.photoURL,
          "phone_number": currentUser.phoneNumber,
          "friend_list": null,
        });
      } on FirebaseException catch (e) {
        debugPrint(e);
      }
    }
  }

  /// Anonymous login
  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException {
      debugPrint("Got an error");
    }
  }

  /// email and password signup
  Future<void> registerWithEmailAndPassword(
      String email, String password, String confiramationPassword) async {
    if (password == confiramationPassword) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        createUser();
      } on FirebaseAuthException catch (e) {
        debugPrint(e);
      }
    } else {}
  }

  // Email and Password Login
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(e);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Google login

  Future<void> googleLogin() async {
    try {
      final googleuser = await GoogleSignIn().signIn();

      if (googleuser == null) return;

      final googleAuth = await googleuser.authentication;
      final authCredental = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(authCredental);
      createUser();
    } on FirebaseAuthException catch (e) {
      debugPrint(e);
    }
  }

  /// Apple Login
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
}
