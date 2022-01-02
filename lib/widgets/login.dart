import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keep/pages/home.dart';
import 'package:flutter_keep/services/auth.dart';
import 'package:flutter_keep/services/firestore_db.dart';
import 'package:flutter_keep/services/login_info.dart';
import 'package:flutter_keep/theme/colors.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text("Login To App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(Buttons.Google, onPressed: () async {
              await signInWithGoogle();
              // ignore: await_only_futures
              final User? currentUser = await _auth.currentUser;
              LocalDataSaver.saveLoginData(true);
              LocalDataSaver.saveImg(currentUser!.photoURL.toString());
              LocalDataSaver.saveMail(currentUser.email.toString());
              LocalDataSaver.saveName(currentUser.displayName.toString());
              LocalDataSaver.saveSync(true);
              await FireDB().getAllStoredNotes();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            })
          ],
        ),
      ),
    );
  }
}
