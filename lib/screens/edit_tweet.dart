import 'package:flutter/material.dart';
import 'package:twitter_clone/firebase/firestore_service.dart';

import 'package:twitter_clone/widgets/edit_tweet_form.dart';

class EditScreen extends StatefulWidget {
  final String currentTitle;
  final String currentDescription;
  final String documentId;

  const EditScreen({
    Key? key,
    required this.currentTitle,
    required this.currentDescription,
    required this.documentId,
  }) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final FocusNode _titleFocusNode = FocusNode();

  final FocusNode _descriptionFocusNode = FocusNode();

  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _descriptionFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Edit Tweet",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          actions: [
            _isDeleting
                ? const Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      right: 16.0,
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.redAccent,
                      ),
                      strokeWidth: 3,
                    ),
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                      size: 32,
                    ),
                    onPressed: () async {
                      setState(() {
                        _isDeleting = true;
                      });

                      await DatabaseService.deleteItem(
                        docId: widget.documentId,
                      );

                      setState(() {
                        _isDeleting = false;
                      });

                      Navigator.of(context).pop();
                    },
                  ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: EditItemForm(
              documentId: widget.documentId,
              titleFocusNode: _titleFocusNode,
              descriptionFocusNode: _descriptionFocusNode,
              currentTitle: widget.currentTitle,
              currentDescription: widget.currentDescription,
            ),
          ),
        ),
      ),
    );
  }
}
