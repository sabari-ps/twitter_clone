import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:twitter_clone/firebase/auth_service.dart';
import 'package:twitter_clone/firebase/firestore_service.dart';
import 'package:twitter_clone/screens/add_tweet.dart';
import 'package:twitter_clone/screens/login_screen.dart';

import 'edit_tweet.dart';

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
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.readItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 16.0),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                String docID = snapshot.data!.docs[index].id;
                String title = snapshot.data!.docs[index]['title'];
                String description = snapshot.data!.docs[index]['description'];

                return Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditScreen(
                          currentTitle: title,
                          currentDescription: description,
                          documentId: docID,
                        ),
                      ),
                    ),
                    title: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.orange,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddScreen(),
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
