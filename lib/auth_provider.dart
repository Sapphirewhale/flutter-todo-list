import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tame_the_beast/models/app_user.dart';
import 'package:tame_the_beast/repositories/user_repository.dart';

class AuthProvider {
  final FirebaseAuth _auth = Get.find<FirebaseAuth>();

  Future<void> signOut() async {
    return _auth.signOut();
  }

  String getUserId() {
    return _auth.currentUser!.uid;
  }

  Future<AppUser> getUser() async {
    return Get.find<UserRepository>().getUser(getUserId());
  }
}
