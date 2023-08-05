import 'package:accomplishr_mobile_app/resources/auth_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:accomplishr_mobile_app/models/user.dart';

class UserProvider with ChangeNotifier {
  User? user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => user!;

  Future<User?> refreshUser() async {
    User userDetails = await _authMethods.getUserDetails();
    user = userDetails;
    notifyListeners();
    return user;
  }
}
