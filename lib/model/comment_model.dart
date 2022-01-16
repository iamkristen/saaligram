import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saaligram/utils/firestore_constant.dart';

class Comment {
  final String uid;
  final String username;
  final String postId;
  final String commentId;
  final String comment;
  final String profileImage;
  final datePublished;
  final likes;

  Comment({
    required this.uid,
    required this.username,
    required this.postId,
    required this.commentId,
    required this.comment,
    required this.profileImage,
    required this.datePublished,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.uid: uid,
      FirestoreConstants.postId: postId,
      FirestoreConstants.commentId: commentId,
      FirestoreConstants.username: username,
      FirestoreConstants.profileImage: profileImage,
      FirestoreConstants.comment: comment,
      FirestoreConstants.datePublished: DateTime.now(),
      FirestoreConstants.likes: likes
    };
  }

  factory Comment.fromDocument(DocumentSnapshot docs) {
    return Comment(
        uid: FirestoreConstants.uid,
        username: FirestoreConstants.username,
        postId: FirestoreConstants.postId,
        comment: FirestoreConstants.comment,
        commentId: FirestoreConstants.commentId,
        profileImage: FirestoreConstants.profileImage,
        datePublished: FirestoreConstants.datePublished,
        likes: FirestoreConstants.likes);
  }
}
