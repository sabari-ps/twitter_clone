import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/screens/home_screen.dart';
import 'package:twitter_clone/screens/login_screen.dart';

import 'firebase/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TwitterCloneApp());
}

class TwitterCloneApp extends StatelessWidget {
  const TwitterCloneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Twitter Clone App",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: AuthServices.auth.authStateChanges(),
        builder: (context, asyncSnapshot) {
          User? user = AuthServices.auth.currentUser;
          if (user == null) {
            return const LoginScreen();
          }
          return HomeScreen(currentUser: user);
        },
      ),
    );
  }
}
