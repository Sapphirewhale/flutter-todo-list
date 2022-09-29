import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tame_the_beast/models/app_user.dart';

class UserRepository {
  FirebaseFirestore firebase = Get.find<FirebaseFirestore>();

  void createUser(String id, String email, String username) {
    AppUser u = AppUser(id: id, email: email, username: username);
    firebase.collection('users').doc(id).set(u.toMap());
  }

  Future<AppUser> getUser(String id) async {
    return AppUser.fromMap(
        (await firebase.collection('users').doc(id).get()).data()!);
  }
}
