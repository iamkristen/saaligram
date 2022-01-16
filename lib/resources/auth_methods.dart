import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saaligram/resources/storage_method.dart';
import 'package:saaligram/utils/firestore_constant.dart';
import 'package:saaligram/model/user_model.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User user = _auth.currentUser!;

    DocumentSnapshot docs = await _firestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(user.uid)
        .get();

    return model.User.fromDocument(docs);
  }

  Future<String> signUpUser(String username, String bio, String email,
      String password, Uint8List? file) async {
    String res = "Error Occured";
    bool isValid = file != null &&
        username.isNotEmpty &&
        bio.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty;
    try {
      if (isValid == true) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim());
        String photoUrl = await StorageMethod().uploadImageToStorage(
            FirestoreConstants.pathProfileImage, file!, false);
        model.User user = model.User(
          uid: _auth.currentUser!.uid,
          username: username,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );
        if (credential.user!.uid.isNotEmpty) {
          await _firestore
              .collection(FirestoreConstants.pathUserCollection)
              .doc(credential.user!.uid)
              .set(user.toJson());
          res = "success";
        }
      } else {
        res = "All fields are required";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "The email is badly formatted";
      } else if (err.code == "weak-password") {
        res = "password should be atleast 6 character";
      } else if (err.code == "email-already-in-use") {
        res = "Email already in use";
      } else if (err.code == "network-request-failed") {
        res = "Network Error";
      } else {
        res = err.toString();
      }
    }
    return res;
  }

  Future<String> updateUser(
      String username, String bio, String email, Uint8List? file) async {
    String res = "Error Occured";
    bool isValid = username.isNotEmpty && bio.isNotEmpty && email.isNotEmpty;
    try {
      if (isValid == true && file != null) {
        String photoUrl = await StorageMethod().uploadImageToStorage(
            FirestoreConstants.pathProfileImage, file, false);
        await _firestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(_auth.currentUser!.uid)
            .update({
          FirestoreConstants.photoUrl: photoUrl,
          FirestoreConstants.username: username,
          FirestoreConstants.bio: bio,
          FirestoreConstants.email: email,
        });
        res = "success";
      } else if (isValid == true) {
        await _firestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(_auth.currentUser!.uid)
            .update({
          FirestoreConstants.username: username,
          FirestoreConstants.bio: bio,
          FirestoreConstants.email: email,
        });
        res = "success";
      } else {
        res = "All fields are required";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "The email is badly formatted";
      } else if (err.code == "weak-password") {
        res = "password should be atleast 6 character";
      } else if (err.code == "email-already-in-use") {
        res = "Email already in use";
      } else if (err.code == "network-request-failed") {
        res = "Network Error";
      } else {
        res = err.toString();
      }
    }
    return res;
  }

  Future<String> loginUser(String email, String password) async {
    String res = "Error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "All fields are required*";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "The email is badly formatted";
      } else if (err.code == "network-request-failed") {
        res = "Network Error";
      } else if (err.code == "wrong-password") {
        res = "Password Incorrect";
      } else if (err.code == "user-not-found") {
        res = "User not found";
      } else if (err.code == "user-disabled") {
        res = "Account temporarily suspended!";
      } else {
        res = err.toString();
      }
    }
    return res;
  }

  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) {
      await _auth.signOut();
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
    } else {
      await _auth.signOut();
    }
  }

  Future<String> handleSignIn() async {
    String res = "SignIn Canceled";
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      User? firebaseUser = (await _auth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot snapshot = await _firestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.uid, isEqualTo: firebaseUser.uid)
            .get();
        List<DocumentSnapshot> document = snapshot.docs;
        if (document.isEmpty) {
          model.User user = model.User(
            uid: firebaseUser.uid,
            username: firebaseUser.displayName!,
            email: firebaseUser.email!,
            bio: "",
            photoUrl: firebaseUser.photoURL!,
            followers: [],
            following: [],
          );
          await _firestore
              .collection(FirestoreConstants.pathUserCollection)
              .doc(firebaseUser.uid)
              .set(user.toJson());
          res = "success";
        } else {
          res = "success";
        }
      } else {
        res = "Unable to SignIn";
      }
    }
    return res;
  }
}
