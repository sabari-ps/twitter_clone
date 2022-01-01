import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference reference = firestore.collection('tweets');

class DatabaseService {
  static String? userId;

  static Future<void> addTweet({
    required String title,
    required String description,
  }) async {
    DocumentReference documentReferencer = reference.doc(userId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .set(data)
        .whenComplete(
          () => print("Tweet added to the database"),
        )
        .catchError(
          (e) => print(e),
        );
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference tweetItemsCollection =
        reference.doc(userId).collection('tweets');

    return tweetItemsCollection.snapshots();
  }

  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        reference.doc(userId).collection('tweets').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(
          () => print("Note item updated in the database"),
        )
        .catchError(
          (e) => print(e),
        );
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        reference.doc(userId).collection('tweets').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
