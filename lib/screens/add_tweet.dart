import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/firebase/auth_service.dart';
import 'package:twitter_clone/firebase/firestore_service.dart';
import 'package:twitter_clone/screens/home_screen.dart';

class AddEditTweet extends StatefulWidget {
  final int mode;
  final User user;

  const AddEditTweet({
    Key? key,
    required this.user,
    required this.mode,
  }) : super(key: key);

  @override
  _AddEditTweetState createState() => _AddEditTweetState();
}

class _AddEditTweetState extends State<AddEditTweet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.mode == 1) ? 'New Tweet' : 'Edit Tweet',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Enter Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLength: 280,
              decoration: const InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.purple.shade100;
                      }
                      return Theme.of(context).primaryColor;
                    },
                  ),
                ),
                child: const Text(
                  'Add Tweet',
                ),
                onPressed: () async {
                  await FirestoreServices.addTweetToFirestore(
                    title: titleController.text,
                    content: descriptionController.text,
                    userId: widget.user.uid,
                  ).then(
                    (value) => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          currentUser: AuthServices.auth.currentUser!,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
