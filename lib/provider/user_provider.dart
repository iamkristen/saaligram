import 'package:flutter/material.dart';
import 'package:saaligram/model/user_model.dart';
import 'package:saaligram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  User? _user;
  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
