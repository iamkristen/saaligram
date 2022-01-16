import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saaligram/provider/user_provider.dart';
import 'package:saaligram/utils/global_variable.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;

  const ResponsiveLayout(
      {Key? key,
      required this.mobileScreenLayout,
      required this.webScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    addData();
    super.initState();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrain) {
      if (constrain.maxWidth > webScreenSize) {
        return widget.webScreenLayout;
      } else {
        return widget.mobileScreenLayout;
      }
    });
  }
}
