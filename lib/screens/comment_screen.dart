import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saaligram/model/user_model.dart';
import 'package:saaligram/provider/user_provider.dart';
import 'package:saaligram/resources/firestore_method.dart';
import 'package:saaligram/utils/firestore_constant.dart';
import 'package:saaligram/utils/global_variable.dart';
import 'package:saaligram/widgets/comments_card.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.postId}) : super(key: key);
  final String postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();

  Future<void> postComment(
      String uid, String username, String profilePicture) async {
    await FirestoreMethods().postComment(
        uid, widget.postId, commentController.text, username, profilePicture);
    setState(() {
      commentController.text = "";
    });
  }

  @override
  void dispose() {
    super.dispose();

    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .25)
            : const EdgeInsets.only(left: 16, right: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 17,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Add a comment..."),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                postComment(user.uid, user.username, user.photoUrl);
              },
              child: const Text(
                "Post",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(FirestoreConstants.pathPostCollection)
              .doc(widget.postId)
              .collection(FirestoreConstants.pathCommentCollection)
              .orderBy(FirestoreConstants.datePublished, descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: MediaQuery.of(context).size.width > webScreenSize
                    ? EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .25)
                    : EdgeInsets.zero,
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CommentsCard(
                          snap: snapshot.data!.docs[index].data());
                    }),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
