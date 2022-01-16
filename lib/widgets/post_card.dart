import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saaligram/resources/firestore_method.dart';
import 'package:saaligram/screens/comment_screen.dart';
import 'package:saaligram/screens/profile_screen.dart';
import 'package:saaligram/utils/colors.dart';
import 'package:saaligram/utils/firestore_constant.dart';
import 'package:saaligram/utils/global_variable.dart';
import 'package:saaligram/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, required this.snap}) : super(key: key);
  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return user != null
        ? Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > webScreenSize
                    ? MediaQuery.of(context).size.width * 0.25
                    : 0,
                vertical:
                    MediaQuery.of(context).size.width > webScreenSize ? 15 : 0),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 23,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: CircleAvatar(
                          radius: 21,
                          backgroundColor: Colors.white,
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        uid: widget
                                            .snap[FirestoreConstants.uid]))),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  widget.snap[FirestoreConstants.profileImage]),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        uid: widget
                                            .snap[FirestoreConstants.uid]))),
                            child: Text(
                              widget.snap[FirestoreConstants.username],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Padding(
                                    padding: MediaQuery.of(context).size.width >
                                            webScreenSize
                                        ? EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .25)
                                        : EdgeInsets.zero,
                                    child: Dialog(
                                        alignment: Alignment.center,
                                        child: ListView(
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            children: [
                                              user.uid ==
                                                      widget.snap[
                                                          FirestoreConstants
                                                              .uid]
                                                  ? InkWell(
                                                      onTap: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        await FirestoreMethods()
                                                            .deletePost(widget
                                                                    .snap[
                                                                FirestoreConstants
                                                                    .postId]);
                                                      },
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 12,
                                                          ),
                                                          child: const Text(
                                                              "Delete")),
                                                    )
                                                  : const Center(
                                                      child: Text(
                                                          "No actions available on other post"),
                                                    ),
                                            ])),
                                  ));
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),
                // Image Section
                GestureDetector(
                  onDoubleTap: () async {
                    await FirestoreMethods().likePost(
                        user.uid,
                        widget.snap[FirestoreConstants.postId],
                        widget.snap[FirestoreConstants.likes]);
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(alignment: Alignment.center, children: [
                    SizedBox(
                      width: double.infinity,
                      child: Image.network(
                        widget.snap[FirestoreConstants.postUrl],
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 200,
                            height: 200,
                            decoration: const BoxDecoration(
                              color: white,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.broken_image_outlined,
                            size: 35,
                            color: Theme.of(context).primaryColor,
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                    LikeAnimation(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 50),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 120,
                        ),
                      ),
                      isAnimation: isLikeAnimating,
                      duration: const Duration(milliseconds: 200),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                    )
                  ]),
                ),

                //Like Comment Section
                Row(
                  children: [
                    LikeAnimation(
                      isAnimation: widget.snap[FirestoreConstants.likes]
                          .contains(user.uid),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          await FirestoreMethods().likePost(
                              user.uid,
                              widget.snap[FirestoreConstants.postId],
                              widget.snap[FirestoreConstants.likes]);
                        },
                        icon: widget.snap[FirestoreConstants.likes]
                                .contains(user.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 30,
                              )
                            : const Icon(
                                Icons.favorite_outline,
                                size: 30,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentScreen(
                                      postId: widget
                                          .snap[FirestoreConstants.postId],
                                    )));
                      },
                      icon: const Icon(
                        Icons.message,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        size: 30,
                      ),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.bookmark_outline,
                          size: 30,
                        ),
                      ),
                    ))
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.w800),
                          child: Text(
                              "${widget.snap[FirestoreConstants.likes].length} Likes")),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8),
                        child: RichText(
                          text: TextSpan(
                              text: widget.snap[FirestoreConstants.username],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                              children: [
                                TextSpan(
                                  text:
                                      "  ${widget.snap[FirestoreConstants.caption]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).primaryColor),
                                )
                              ]),
                        ),
                      ),
                      //Comment Section

                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(FirestoreConstants.pathPostCollection)
                              .doc(widget.snap[FirestoreConstants.postId])
                              .collection(
                                  FirestoreConstants.pathCommentCollection)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommentScreen(
                                                postId: widget.snap[
                                                    FirestoreConstants.postId],
                                              )));
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: snapshot.data!.docs.isNotEmpty
                                      ? Text(
                                          "View all ${snapshot.data!.docs.length} Comments")
                                      : const Padding(padding: EdgeInsets.zero),
                                ),
                              );
                            }

                            return const Padding(padding: EdgeInsets.zero);
                          }),
                      Text(
                        DateFormat.yMMMd().format(widget
                            .snap[FirestoreConstants.datePublished]
                            .toDate()),
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
