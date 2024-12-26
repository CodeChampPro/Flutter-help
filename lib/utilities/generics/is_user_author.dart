import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';

Future<bool> isUserAuthor(documentId) async {
  var userId = '';
 
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var collection = FirebaseFirestore.instance.collection('notes');
  var docSnapshot = await collection.doc(documentId).get();
  var collectionAngebote = FirebaseFirestore.instance.collection('notesAngebote');
 
  
  


    
  if (docSnapshot.exists) {
    userId = docSnapshot.data()?['user_id'];
  } else {
    docSnapshot = await collectionAngebote.doc(documentId).get();
    userId = docSnapshot.data()?['user_id'];
  }
  if (userId == currentUserId) {
    return true;
  } else {
    return false;
  }
}
