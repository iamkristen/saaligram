import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saaligram/model/user_model.dart';
import 'package:saaligram/provider/user_provider.dart';
import 'package:saaligram/resources/firestore_method.dart';
import 'package:saaligram/utils/firestore_constant.dart';
import 'package:saaligram/widgets/like_animation.dart';

class CommentsCard extends StatefulWidget {
  const CommentsCard({Key? key, required this.snap}) : super(key: key);
  final snap;

  @override
  _CommentsCardState createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: Theme.of(context).primaryColor,
            child: CircleAvatar(
                radius: 21,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      widget.snap[FirestoreConstants.profileImage]),
                )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.snap[FirestoreConstants.username],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(widget.snap[FirestoreConstants.comment])
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        DateFormat.yMMMd().format(widget
                            .snap[FirestoreConstants.datePublished]
                            .toDate()),
                        style: Theme.of(context).textTheme.caption,
                      ),
                      widget.snap[FirestoreConstants.likes].length > 0
                          ? const SizedBox(
                              width: 15,
                            )
                          : const SizedBox.shrink(),
                      widget.snap[FirestoreConstants.likes].length > 0
                          ? Text(
                              "${widget.snap[FirestoreConstants.likes].length} likes",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontWeight: FontWeight.w600),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                          onTap: () {},
                          child: Text(
                            "Reply",
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
          LikeAnimation(
            isAnimation:
                widget.snap[FirestoreConstants.likes].contains(user.uid),
            smallLike: true,
            child: GestureDetector(
              onTap: () async {
                await FirestoreMethods().likeComment(
                    user.uid,
                    widget.snap[FirestoreConstants.postId],
                    widget.snap[FirestoreConstants.commentId],
                    widget.snap[FirestoreConstants.likes]);
              },
              child: widget.snap[FirestoreConstants.likes].contains(user.uid)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    )
                  : const Icon(
                      Icons.favorite_outline,
                      size: 20,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
