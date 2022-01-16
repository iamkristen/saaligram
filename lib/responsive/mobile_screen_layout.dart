import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saaligram/screens/activity.dart';
import 'package:saaligram/screens/add_post_screen.dart';
import 'package:saaligram/screens/feed_screen.dart';
import 'package:saaligram/screens/profile_screen.dart';
import 'package:saaligram/screens/search_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int pageIndex = 0;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: onPageChanged,
        controller: pageController,
        children: [
          const FeedScreen(),
          const SearchScreen(),
          const AddPost(),
          const ActivityScreen(),
          ProfileScreen(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Colors.grey,
        currentIndex: pageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
            Icons.home,
            size: 35,
          )),
          BottomNavigationBarItem(icon: Icon(Icons.search, size: 35)),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 35)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline, size: 35)),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 35)),
        ],
        onTap: navigationTap,
      ),
    );
  }
}
