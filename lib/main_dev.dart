import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tame_the_beast/firebase_options.dart';
import 'package:tame_the_beast/homepage.dart';
import 'package:tame_the_beast/repositories/user_repository.dart';

void initDependencies() {
  Get.put(FirebaseFirestore.instance);
  Get.put(FirebaseAuth.instance);
  Get.put(UserRepository());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: '[DEFAULT]',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
    FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
  } catch (error) {
    // throws a JavaScript object instead of a FirebaseException
    final String code = (error as dynamic).code;
    if (code != "failed-precondition") {
      rethrow;
    }
  }

  initDependencies();

  runApp(const MyApp());
}
