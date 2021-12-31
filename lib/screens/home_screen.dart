import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:twitter_clone/firebase/auth_service.dart';
import 'package:twitter_clone/firebase/firestore_service.dart';
import 'package:twitter_clone/screens/add_tweet.dart';
import 'package:twitter_clone/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final User currentUser;

  const HomeScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference tweets = FirestoreServices.firestore.collection('tweets');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Hello, ${widget.currentUser.email}",
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthServices.auth.signOut().then(
                    (_) => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                  );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: tweets
            .doc(widget.currentUser.uid.toString())
            .collection('myTweets')
            .get(),
        builder: (context, snapshot) {
          Map<String, dynamic> userTweets =
              snapshot.data! as Map<String, dynamic>;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (!snapshot.hasData) {
            return const Text("Document does not exist");
          }
          return ListView.builder(
            itemCount: userTweets.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: userTweets['title'],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditTweet(
                user: widget.currentUser,
                mode: 1,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
