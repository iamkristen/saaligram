import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saaligram/screens/activity.dart';
import 'package:saaligram/screens/add_post_screen.dart';
import 'package:saaligram/screens/feed_screen.dart';
import 'package:saaligram/screens/profile_screen.dart';
import 'package:saaligram/screens/search_screen.dart';
import 'package:saaligram/utils/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int pageIndex = 0;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void onPageChanged(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  void navigationTap(int pageIndex) {
    pageController!.jumpToPage(pageIndex);
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Saaligram",
            style: TextStyle(
                fontFamily: "signatra", fontSize: 50, letterSpacing: 2.5),
          ),
          actions: [
            IconButton(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              onPressed: () => navigationTap(0),
              icon: Icon(
                Icons.home,
                color: pageIndex == 0 ? white : grey,
              ),
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              onPressed: () => navigationTap(1),
              icon: Icon(
                Icons.search,
                color: pageIndex == 1 ? white : grey,
              ),
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              onPressed: () => navigationTap(2),
              icon: Icon(
                Icons.add_a_photo,
                color: pageIndex == 2 ? white : grey,
              ),
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              onPressed: () => navigationTap(3),
              icon: Icon(
                Icons.favorite,
                color: pageIndex == 3 ? white : grey,
              ),
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              onPressed: () => navigationTap(4),
              icon: Icon(
                Icons.person,
                color: pageIndex == 4 ? white : grey,
              ),
            ),
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
          children: [
            const FeedScreen(),
            const SearchScreen(),
            const AddPost(),
            const ActivityScreen(),
            ProfileScreen(
              uid: FirebaseAuth.instance.currentUser!.uid,
            ),
          ],
        ));
  }
}
