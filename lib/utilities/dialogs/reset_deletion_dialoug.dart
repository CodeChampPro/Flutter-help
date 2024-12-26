import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Timestamp deletionTimer = Timestamp.now();

Future<Timestamp> fetchNoteData(String documentId) async {
  var collection = FirebaseFirestore.instance.collection('notes');
  var collectionAngebote = FirebaseFirestore.instance.collection('notesAngebote');


  var docSnapshot = await collection.doc(documentId).get();
  if (docSnapshot.exists) {
    var data = docSnapshot.data();
    if (data != null && data.containsKey('deletionTime')) {
      deletionTimer = data['deletionTime'] as Timestamp;
    } else {
      deletionTimer = Timestamp.now(); 
    }
    return deletionTimer;
  } else {
    docSnapshot = await collectionAngebote.doc(documentId).get();
    var data = docSnapshot.data();
    if (data != null && data.containsKey('deletionTime')) {
      deletionTimer = data['deletionTime'] as Timestamp;
    } else {
      deletionTimer = Timestamp.now(); 
    }
    return deletionTimer;
  }
}

Future<String?> showResetDeletionDialog(BuildContext context, String documentId) async {
  final Timestamp timeToDeletion = await fetchNoteData(documentId);
  final DateTime dateTimeToDeletion = timeToDeletion.toDate();
  final DateTime now = DateTime.now();
  final difference = dateTimeToDeletion.difference(now).inDays;
  final String stringDifferenceToDeletion = difference.toString();
  return showGenericDialog<String?>(
    context: context,
    title: context.loc.delete,
    content: 'your note will be deleted in $stringDifferenceToDeletion days',
    optionsBuilder: () => {
      context.loc.ok: 'ok',
      'reset ': 'reset'
    },
  );
}