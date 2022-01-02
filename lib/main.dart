import 'package:flutter/material.dart';
import 'package:flutter_keep/pages/home.dart';
import 'package:flutter_keep/services/login_info.dart';
import 'package:flutter_keep/theme/colors.dart';
import 'package:flutter_keep/widgets/login.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogIn = false;

  getLoggedInState() async {
    await LocalDataSaver.getLogData().then((value) {
      setState(() {
        isLogIn = value.toString() == "null";
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getLoggedInState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: white,
      ),
      home: isLogIn ? const Login() : const Home(),
    );
  }
}
