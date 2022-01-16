import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saaligram/utils/firestore_constant.dart';

class User {
  final String username;
  final String email;
  final String bio;
  final String uid;
  final String photoUrl;
  final List followers;
  final List following;

  User(
      {required this.username,
      required this.email,
      required this.bio,
      required this.uid,
      required this.photoUrl,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.username: username,
      FirestoreConstants.email: email,
      FirestoreConstants.bio: bio,
      FirestoreConstants.uid: uid,
      FirestoreConstants.photoUrl: photoUrl,
      FirestoreConstants.followers: followers,
      FirestoreConstants.following: following,
    };
  }

  factory User.fromDocument(DocumentSnapshot docs) {
    return User(
      username: docs[FirestoreConstants.username],
      email: docs[FirestoreConstants.email],
      bio: docs[FirestoreConstants.bio],
      photoUrl: docs[FirestoreConstants.photoUrl],
      uid: docs[FirestoreConstants.uid],
      following: docs[FirestoreConstants.following],
      followers: docs[FirestoreConstants.followers],
    );
  }
}
