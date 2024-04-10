import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorageAngebote {
  final notesAngebote = FirebaseFirestore.instance.collection('notesAngebote');

  Future<void> deleteNoteAngebote({required String documentId}) async {
    try {
      await notesAngebote.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

Future<void> updateNoteAngebote({
    required String documentId,
    required String textJob,
    required String textAdresse,
    required String textBezahlung,
    required String textKontakt,
    required String textZeit,
    required String textStadt,
    required String textStadtviertel
  }) async {
    try {
      await notesAngebote.doc(documentId).update({
        textJobFieldName: textJob,
        textAdresseFieldName: textAdresse,
        textBezahlungFieldName: textBezahlung,
        textKontaktFieldName: textKontakt,
        textZeitFieldName: textZeit,
        textStadtviertelFieldName: textStadtviertel,
        textStadtFieldName: textStadt,
      });
      print("yes");
    } catch (e) {
      print('no');
      print(e);
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotesAngebote(String searchResult) {
    final allNotes = notesAngebote
        .orderBy('jobText', descending: true)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }
    
    

  Future<CloudNote> createNewNoteAngebote({required String ownerUserId}) async {
    final deletionTime = DateTime.now().add(const Duration(days: 14));
    final deletionTimestamp = Timestamp.fromDate(deletionTime);
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final document = await notesAngebote.add({
      ownerUserIdFieldName: ownerUserId,
      textJobFieldName: '',
      textAdresseFieldName: '',
      textBezahlungFieldName: '',
      textKontaktFieldName: '',
      textZeitFieldName: '',
      textStadtFieldName:'',
      textStadtviertelFieldName: '',
      textAngebotFieldName: '',
      deletionTimeFieldName: deletionTime,
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
      textAngebot: '',
      deletionTime: deletionTimestamp,
      userId: '',
    );
  }

  static final FirebaseCloudStorageAngebote _shared =
      FirebaseCloudStorageAngebote._sharedInstance();
  FirebaseCloudStorageAngebote._sharedInstance();
  factory FirebaseCloudStorageAngebote() => _shared;
}
