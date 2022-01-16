import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saaligram/screens/profile_screen.dart';
import 'package:saaligram/utils/colors.dart';
import 'package:saaligram/utils/firestore_constant.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({Key? key, required this.snapshot}) : super(key: key);
  final snapshot;

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snapshot[FirestoreConstants.type] == "follow") {
      return FutureBuilder(
          future: FirebaseFirestore.instance
              .collection(FirestoreConstants.pathUserCollection)
              .doc(widget.snapshot[FirestoreConstants.eventUserId])
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(padding: EdgeInsets.zero),
              );
            }
            return ListTile(
              tileColor: primaryColor.withOpacity(.1),
              leading: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                          uid: widget.snapshot[FirestoreConstants.eventUserId]),
                    )),
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(snap.data![FirestoreConstants.photoUrl]),
                    ),
                  ),
                ),
              ),
              title: Text.rich(
                TextSpan(
                    text: snap.data![FirestoreConstants.username],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    children: const [
                      TextSpan(
                        text: " started following you.",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ]),
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(
                    widget.snapshot[FirestoreConstants.datePublished].toDate()),
                style: Theme.of(context).textTheme.caption,
              ),
            );
          });
    } else if (widget.snapshot[FirestoreConstants.type] == "likes") {
      return FutureBuilder(
          future: FirebaseFirestore.instance
              .collection(FirestoreConstants.pathUserCollection)
              .doc(widget.snapshot[FirestoreConstants.eventUserId])
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(padding: EdgeInsets.zero),
              );
            }
            return ListTile(
              tileColor: primaryColor.withOpacity(.1),
              leading: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                          uid: widget.snapshot[FirestoreConstants.eventUserId]),
                    )),
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(snap.data![FirestoreConstants.photoUrl]),
                    ),
                  ),
                ),
              ),
              title: Text.rich(
                TextSpan(
                    text: snap.data![FirestoreConstants.username],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    children: const [
                      TextSpan(
                        text: " liked your post.",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ]),
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(
                    widget.snapshot[FirestoreConstants.datePublished].toDate()),
                style: Theme.of(context).textTheme.caption,
              ),
              trailing: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: NetworkImage(
                              widget.snapshot[FirestoreConstants.postUrl])))),
            );
          });
    } else if (widget.snapshot[FirestoreConstants.type] == "comments") {
      return FutureBuilder(
          future: FirebaseFirestore.instance
              .collection(FirestoreConstants.pathUserCollection)
              .doc(widget.snapshot[FirestoreConstants.eventUserId])
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(padding: EdgeInsets.zero),
              );
            }
            return ListTile(
              tileColor: primaryColor.withOpacity(.1),
              leading: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                          uid: widget.snapshot[FirestoreConstants.eventUserId]),
                    )),
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(snap.data![FirestoreConstants.photoUrl]),
                    ),
                  ),
                ),
              ),
              title: Text.rich(
                TextSpan(
                    text: snap.data![FirestoreConstants.username],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    children: const [
                      TextSpan(
                        text: " commented on your post.",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ]),
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(
                    widget.snapshot[FirestoreConstants.datePublished].toDate()),
                style: Theme.of(context).textTheme.caption,
              ),
              trailing: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: NetworkImage(
                              widget.snapshot[FirestoreConstants.postUrl])))),
            );
          });
    }
    return const Text("NoData");
  }
}
