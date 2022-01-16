import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saaligram/utils/firestore_constant.dart';
import 'package:saaligram/utils/global_variable.dart';
import 'package:saaligram/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width > webScreenSize
          ? null
          : AppBar(
              // centerTitle: true,
              title: const Text(
                "Saaligram",
                style: TextStyle(
                    fontFamily: "signatra", fontSize: 50, letterSpacing: 2.5),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message_outlined),
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreConstants.pathPostCollection)
            .orderBy(FirestoreConstants.datePublished, descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Post Available"),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return PostCard(snap: snapshot.data!.docs[index].data());
              });
        },
      ),
    );
  }
}
