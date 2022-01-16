import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saaligram/utils/colors.dart';
import 'package:saaligram/utils/firestore_constant.dart';
import 'package:saaligram/utils/global_variable.dart';
import 'package:saaligram/widgets/activity_card.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MediaQuery.of(context).size.width > webScreenSize
            ? null
            : AppBar(
                title: const Text("Activity"),
                centerTitle: true,
              ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(FirestoreConstants.pathActivityCollection)
              .where(FirestoreConstants.uid,
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy(FirestoreConstants.datePublished, descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No Activity"),
              );
            }
            return Container(
              margin: MediaQuery.of(context).size.width > webScreenSize
                  ? EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: MediaQuery.of(context).size.width * .25)
                  : EdgeInsets.zero,
              decoration: MediaQuery.of(context).size.width > webScreenSize
                  ? BoxDecoration(
                      border: Border.all(color: primaryColor.withOpacity(.3)),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    )
                  : null,
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ActivityCard(
                      snapshot: snapshot.data!.docs[index].data(),
                    );
                  }),
            );
          },
        ));
  }
}
