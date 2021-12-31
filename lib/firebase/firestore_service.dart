import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> addTweetToFirestore({
    required String title,
    required String content,
    required String userId,
  }) async {
    var time = DateTime.now();
    await firestore
        .collection('tweets')
        .doc(userId.toString())
        .collection('myTweets')
        .doc(time.toString())
        .set({
      'title': title,
      'content': content,
      'time': time.toString(),
      'timestamp': time
    });
    Fluttertoast.showToast(msg: 'Tweet Added');
  }
}
