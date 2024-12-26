import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String textJob,
    required String textAdresse,
    required String textBezahlung,
    required String textKontakt,
    required String textZeit,
    required String textStadt,
    required String textStadtviertel,
    DateTime? deletionTime,
  }) async {
   if(documentId != ''){
    await notes.doc(documentId).update({
        textJobFieldName: textJob,
        textAdresseFieldName: textAdresse,
        textBezahlungFieldName: textBezahlung,
        textKontaktFieldName: textKontakt,
        textZeitFieldName: textZeit,
        textStadtviertelFieldName: textStadtviertel,
        textStadtFieldName: textStadt,
      });
      if(deletionTime != null){
        await notes.doc(documentId).update({
          deletionTimeFieldName: deletionTime,
        });
      }
    }
  }

  Stream<Iterable<CloudNote>> allNotes(String searchResult) {
    final allNotes = notes
        .orderBy('jobText', descending: true)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }
    
    

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final deletionTime = DateTime.now().add(const Duration(days: 14));
    final deletionTimestamp = Timestamp.fromDate(deletionTime);
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textJobFieldName: '',
      textAdresseFieldName: '',
      textBezahlungFieldName: '',
      textKontaktFieldName: '',
      textZeitFieldName: '',
      textStadtFieldName:'',
      textStadtviertelFieldName: '',
      textAngebotFieldName: 'noteNotAngebot',
      deletionTimeFieldName: deletionTimestamp,
      userIdFieldName: currentUserId,
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      textJob: '',
      textAdresse: '',
      textBezahlung: '',
      textKontakt: '',
      textZeit: '',
      textStadt: '',
      textStadtviertel: '',
      textAngebot: 'noteNotAngebot',
      deletionTime: deletionTimestamp,
      userId: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
