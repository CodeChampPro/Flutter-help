import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/notes/edit_notes_view.dart';

class ShowNoteView extends StatefulWidget {
  final String documentId;
  const ShowNoteView({Key? key, required this.documentId}) : super(key: key);

  @override
  _ShowNoteViewState createState() => _ShowNoteViewState();
}

class _ShowNoteViewState extends State<ShowNoteView> {
  String jobText = 'Loading...'; // Initial value
  String adresseText = 'Loading...';
  String zeitText = 'Loading...';
  String kontaktText = 'Loading...';
  String bezahlungText = 'Loading...';
  String stadtText = 'Loading...';
  String stadtviertelText = 'Loading...';

  String userId = '';
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var visibility = false;

  final isAuthorTrue = false;

  @override
  void initState() {
    super.initState();
    fetchNoteData(widget.documentId);
  }

  Future<void> fetchNoteData(String documentId) async {
    var collection = FirebaseFirestore.instance.collection('notes');
    var docSnapshot = await collection.doc(documentId).get();
    if (docSnapshot.exists) {
      setState(() {
        jobText = docSnapshot.data()?['jobText'] ?? 'No data';
        adresseText = docSnapshot.data()?['adresseText'] ?? 'No data';
        zeitText = docSnapshot.data()?['zeitText'] ?? 'No data';
        bezahlungText = docSnapshot.data()?['bezahlungText'] ?? 'No data';
        kontaktText = docSnapshot.data()?['kontaktText'] ?? 'No data';
        stadtText = docSnapshot.data()?['stadtText'] ?? 'No data';
        stadtviertelText = docSnapshot.data()?['stadtviertelText'] ?? 'No data';
        userId = docSnapshot.data()?['user_id'];
      });
    } else {
      setState(() {
        jobText = 'Document not found';
        adresseText = 'Document not found';
      });
    }
    if (userId == currentUserId) {
      visibility = true;
    } else {
      visibility = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(jobText),
        backgroundColor: Colors.green.shade200,
        actions: [
          Visibility(
              visible: visibility,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => EditNotesView(
                              documentId: widget.documentId,
                            )),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.edit),
              ))
        ],
      ),
      body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              jobText,
              style: const TextStyle(fontSize: 45),
            ),
            const SizedBox(height: 16), 
            Text(
              zeitText,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              stadtText,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              stadtviertelText,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16), 
            Text(
              adresseText,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16), 
            Text(
              bezahlungText,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16), 
            Text(
              kontaktText,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    ),
  );
}
    
  }

