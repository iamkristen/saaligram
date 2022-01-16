import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:saaligram/screens/profile_screen.dart';
import 'package:saaligram/utils/firestore_constant.dart';
import 'package:saaligram/utils/global_variable.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShow = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    searchController.text = "";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: TextField(
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                isShow = false;
              });
            }
          },
          controller: searchController,
          onSubmitted: (_) {
            setState(() {
              isShow = true;
            });
          },
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            hintText: "Search",
            hintStyle: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() {
                searchController.text = "";
                isShow = false;
              }),
            ),
            prefixIcon: const Icon(
              Icons.search,
              size: 30,
            ),
            filled: true,
            fillColor: Theme.of(context).primaryColor.withOpacity(0.15),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(35.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(35.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(35.0),
            ),
          ),
        ),
      ),
      body: isShow
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection(FirestoreConstants.pathUserCollection)
                  .where(FirestoreConstants.username,
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    uid: snapshot.data!.docs[index]
                                        [FirestoreConstants.uid]))),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data!
                                .docs[index][FirestoreConstants.photoUrl]),
                          ),
                          title: Text(
                            snapshot.data!.docs[index]
                                [FirestoreConstants.username],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            snapshot.data!.docs[index][FirestoreConstants.bio],
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      );
                    });
              },
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(FirestoreConstants.pathPostCollection)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return MediaQuery.of(context).size.width > webScreenSize
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        child: StaggeredGridView.countBuilder(
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            crossAxisCount: 3,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => Image.network(
                                snapshot.data!.docs[index]
                                    [FirestoreConstants.postUrl]),
                            staggeredTileBuilder: (index) =>
                                StaggeredTile.count(
                                  (index % 7 == 0) ? 2 : 1,
                                  (index % 7 == 0) ? 2 : 1,
                                )),
                      )
                    : StaggeredGridView.countBuilder(
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        crossAxisCount: 3,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => Image.network(snapshot
                            .data!.docs[index][FirestoreConstants.postUrl]),
                        staggeredTileBuilder: (index) => StaggeredTile.count(
                              (index % 7 == 0) ? 2 : 1,
                              (index % 7 == 0) ? 2 : 1,
                            ));
              }),
    );
  }
}
