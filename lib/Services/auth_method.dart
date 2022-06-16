import 'package:firebase_auth/firebase_auth.dart';

import '../helper/shared_preference_helper.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get current user
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  //
  Future signOut() async {
    try {
      // remove all shared preference info
      SharedPreferenceHelper.clearData();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}