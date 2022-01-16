import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saaligram/model/comment_model.dart';
import 'package:saaligram/model/post_model.dart';
import 'package:saaligram/resources/storage_method.dart';
import 'package:saaligram/utils/firestore_constant.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(Uint8List? file, String? caption, String uid,
      String username, String profileImage) async {
    String res = "Error occured";
    try {
      if (file != null) {
        String photoUrl = await StorageMethod()
            .uploadImageToStorage(FirestoreConstants.pathPostImage, file, true);
        String postId = const Uuid().v1();
        Post _post = Post(
            caption: caption ?? "",
            uid: uid,
            username: username,
            postId: postId,
            datePublished: DateTime.now(),
            postUrl: photoUrl,
            profileImage: profileImage,
            likes: []);

        await _firestore
            .collection(FirestoreConstants.pathPostCollection)
            .doc(postId)
            .set(_post.toJson());
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection(FirestoreConstants.pathPostCollection)
            .doc(postId)
            .update({
          FirestoreConstants.likes: FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection(FirestoreConstants.pathPostCollection)
            .doc(postId)
            .update({
          FirestoreConstants.likes: FieldValue.arrayUnion([uid])
        });

        DocumentSnapshot snapshot = await _firestore
            .collection(FirestoreConstants.pathPostCollection)
            .doc(postId)
            .get();
        if (snapshot[FirestoreConstants.uid] != uid) {
          addActivity("likes", snapshot[FirestoreConstants.uid], uid,
              snapshot[FirestoreConstants.postUrl]);
        }
      }
    } catch (err) {
      // print(err.toString());
    }
  }

  Future<void> postComment(String uid, String postId, String comment,
      String username, String profilePicture) async {
    try {
      String commentId = const Uuid().v1();
      if (comment.isNotEmpty) {
        Comment _comment = Comment(
            uid: uid,
            username: username,
            postId: postId,
            comment: comment,
            commentId: commentId,
            profileImage: profilePicture,
            datePublished: DateTime.now(),
            likes: []);
        await _firestore
            .collection(FirestoreConstants.pathPostCollection)
            .doc(postId)
            .collection(FirestoreConstants.pathCommentCollection)
            .doc(commentId)
            .set(_comment.toJson());

        DocumentSnapshot snapshot = await _firestore
            .collection(FirestoreConstants.pathPostCollection)
            .doc(postId)
            .get();
        if (snapshot[FirestoreConstants.uid] != uid) {
          addActivity("comments", snapshot[FirestoreConstants.uid], uid,
              snapshot[FirestoreConstants.postUrl]);
        }
      }
    } catch (err) {}
  }

  Future<void> likeComment(
      String uid, String postId, String commentId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection(FirestoreConstants.pathPostCollection)
            .doc(postId)
            .collection(FirestoreConstants.pathCommentCollection)
            .doc(commentId)
            .update({
          FirestoreConstants.likes: FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection(FirestoreConstants.pathPostCollection)
            .doc(postId)
            .collection(FirestoreConstants.pathCommentCollection)
            .doc(commentId)
            .update({
          FirestoreConstants.likes: FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      // print(err.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore
          .collection(FirestoreConstants.pathPostCollection)
          .doc(postId)
          .delete();
    } catch (err) {}
  }

  Future<void> followUser(String uid, String accountId) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(uid)
          .get();
      List following =
          (snapshot.data()! as dynamic)[FirestoreConstants.following];
      if (following.contains(accountId)) {
        await _firestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(accountId)
            .update({
          FirestoreConstants.followers: FieldValue.arrayRemove([uid]),
        });

        await _firestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(uid)
            .update({
          FirestoreConstants.following: FieldValue.arrayRemove([accountId]),
        });
      } else {
        await _firestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(accountId)
            .update({
          FirestoreConstants.followers: FieldValue.arrayUnion([uid]),
        });
        await _firestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(uid)
            .update({
          FirestoreConstants.following: FieldValue.arrayUnion([accountId]),
        });
        addActivity("follow", accountId, uid, "");
      }
    } catch (err) {}
  }

  Future<void> addActivity(String postType, String userId, String eventUserId,
      String postUrl) async {
    await _firestore.collection(FirestoreConstants.pathActivityCollection).add({
      FirestoreConstants.type: postType,
      FirestoreConstants.uid: userId,
      FirestoreConstants.eventUserId: eventUserId,
      FirestoreConstants.postUrl: postUrl,
      FirestoreConstants.datePublished: DateTime.now(),
    });
  }
}
