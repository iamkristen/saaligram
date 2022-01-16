import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saaligram/utils/firestore_constant.dart';

class Post {
  final String caption;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImage;
  final List likes;

  Post(
      {required this.caption,
      required this.uid,
      required this.username,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profileImage,
      required this.likes});

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.caption: caption,
      FirestoreConstants.uid: uid,
      FirestoreConstants.username: username,
      FirestoreConstants.postId: postId,
      FirestoreConstants.postUrl: postUrl,
      FirestoreConstants.datePublished: datePublished,
      FirestoreConstants.profileImage: profileImage,
      FirestoreConstants.likes: likes,
    };
  }

  factory Post.fromDocument(DocumentSnapshot docs) {
    return Post(
        caption: docs[FirestoreConstants.caption],
        uid: docs[FirestoreConstants.uid],
        username: docs[FirestoreConstants.username],
        postId: docs[FirestoreConstants.postId],
        datePublished: docs[FirestoreConstants.datePublished],
        postUrl: docs[FirestoreConstants.postUrl],
        profileImage: docs[FirestoreConstants.profileImage],
        likes: docs[FirestoreConstants.likes]);
  }
}
