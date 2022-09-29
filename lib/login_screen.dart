import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tame_the_beast/repositories/user_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool loggingIn = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      child: Column(
        children: [
          const Text("Email:"),
          TextField(
            controller: _emailController,
          ),
          if (!loggingIn) const Text("Username:"),
          if (!loggingIn)
            TextField(
              controller: _usernameController,
            ),
          const Text("Password:"),
          TextField(
            obscureText: true,
            controller: _passwordController,
          ),
          ElevatedButton(
            onPressed: () => (loggingIn ? login() : register()),
            child: Text(loggingIn ? "Log In" : "Register"),
          ),
          InkWell(
              child: Text(loggingIn
                  ? "Don't have an account?"
                  : "Already have an account?"),
              onTap: () => setState(
                    () => loggingIn = !loggingIn,
                  )),
        ],
      ),
    );
  }

  void login() {
    Get.find<FirebaseAuth>().signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
  }

  void register() async {
    var cred = await Get.find<FirebaseAuth>().createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    Get.find<UserRepository>().createUser(
        cred.user!.uid, _emailController.text, _usernameController.text);
  }
}
