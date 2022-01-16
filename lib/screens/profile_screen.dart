import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saaligram/resources/auth_methods.dart';
import 'package:saaligram/resources/firestore_method.dart';
import 'package:saaligram/screens/edit_profile_screen.dart';
import 'package:saaligram/screens/login_screen.dart';
import 'package:saaligram/utils/firestore_constant.dart';
import 'package:saaligram/utils/global_variable.dart';
import 'package:saaligram/utils/utilities.dart';
import 'package:saaligram/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  final uid;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _image;

  var userData = {};
  var postLen = 0;
  var followers = 0;
  var following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userSnap = await FirebaseFirestore.instance
          .collection(FirestoreConstants.pathUserCollection)
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection(FirestoreConstants.pathPostCollection)
          .where(FirestoreConstants.uid, isEqualTo: widget.uid)
          .get();
      userData = userSnap.data()!;
      postLen = postSnap.docs.length;
      followers = userSnap.data()![FirestoreConstants.followers].length;
      following = userSnap.data()![FirestoreConstants.following].length;
      isFollowing = userSnap
          .data()![FirestoreConstants.followers]
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(userData[FirestoreConstants.username]),
            ),
            body: Padding(
              padding: MediaQuery.of(context).size.width > webScreenSize
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.2)
                  : const EdgeInsets.all(0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 43,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: CircleAvatar(
                                  radius: 41,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                      userData[FirestoreConstants.photoUrl],
                                    ),
                                  )),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  buildStateColumn(
                                      number: postLen.toString(),
                                      text: "Posts"),
                                  buildStateColumn(
                                      number: followers.toString(),
                                      text: "Followers"),
                                  buildStateColumn(
                                      number: following.toString(),
                                      text: "Following")
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userData[FirestoreConstants.username],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.60),
                          child: Text(userData[FirestoreConstants.bio]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: (widget.uid ==
                                        FirebaseAuth.instance.currentUser!.uid)
                                    ? CustomButton(
                                        onPressed: () async {
                                          bool? isDone = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfileScreen(
                                                          user: userData)));
                                          if (isDone == true) {
                                            setState(() {
                                              getData();
                                            });
                                          }
                                        },
                                        child: const Text("Edit Profile"),
                                      )
                                    : isFollowing
                                        ? CustomButton(
                                            onPressed: () async {
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                              await FirestoreMethods()
                                                  .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      widget.uid);
                                            },
                                            child: const Text("Unfollow"),
                                          )
                                        : CustomButton(
                                            onPressed: () async {
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                              await FirestoreMethods()
                                                  .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      widget.uid);
                                            },
                                            child: const Text("Follow"),
                                          )),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: CustomButton(
                                    onPressed: () {
                                      AuthMethods().signOut();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    },
                                    child: const Text("Sign Out"))),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: CustomButton(
                                    onPressed: () {
                                      Fluttertoast.showToast(
                                          msg: "No insights available");
                                    },
                                    child: const Text("Insights"))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: .6,
                  ),
                  Column(
                    children: [
                      FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection(FirestoreConstants.pathPostCollection)
                              .where(FirestoreConstants.uid,
                                  isEqualTo: widget.uid)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.data!.docs.isNotEmpty) {
                              return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 2,
                                          crossAxisSpacing: 2),
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot snap =
                                        snapshot.data!.docs[index];
                                    return Image(
                                      image: NetworkImage(
                                        snap[FirestoreConstants.postUrl],
                                      ),
                                      fit: BoxFit.cover,
                                    );
                                  });
                            } else {
                              return const Center(
                                child: Text("No Posts Available"),
                              );
                            }
                          }),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  Column buildStateColumn({required String text, required String number}) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 17),
        ),
      ],
    );
  }
}
