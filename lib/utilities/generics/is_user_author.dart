import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> isUserAuthor(documentId) async {
  var userId = '';
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var collection = FirebaseFirestore.instance.collection('notes');
  var docSnapshot = await collection.doc(documentId).get();
  
  if (docSnapshot.exists) {
    userId = docSnapshot.data()?['user_id'];
  } else {
    userId = 'no User available';

  }
  if (userId == currentUserId) {
    return true;
  } else {
    return false;
  }
}
