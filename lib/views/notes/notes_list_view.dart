import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage_angebote.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';
import 'package:mynotes/utilities/dialogs/reset_deletion_dialoug.dart';
import 'package:mynotes/utilities/generics/is_user_author.dart';

typedef NoteCallback = void Function(CloudNote note);
final _notesService = FirebaseCloudStorage();
final _notesServiceAngebote = FirebaseCloudStorageAngebote();
 String jobText = 'Loading...'; // Initial value
  String adresseText = 'Loading...';
  String zeitText = 'Loading...';
  String kontaktText= 'Loading...';
  String bezahlungText = 'Loading...';
  String stadtText = 'Loading...';
  String stadtteilText = 'Loading...';
  var selectedOption = 'Wählen sie was sie haben wollen';
  var result = '';
  var selectedOptionStadt= 'In welcher Stadt wohnen sie';
  var selectedOptionStadtteil = 'In welchem stadtteil wohnen sie?';

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  void resetDeletiontimerFunction(documentId) async {
    final isAngebotefun = await isAngebot(documentId);
    var collection = FirebaseFirestore.instance.collection('notesAngebote');
    var docSnapshot = await collection.doc(documentId).get();
    if (isAngebotefun == true) {
        jobText = docSnapshot.data()?['jobText'] ?? 'No data';
        adresseText = docSnapshot.data()?['adresseText'] ?? 'No data';
        stadtText = docSnapshot.data()?['stadtText'] ?? 'No data';
        stadtteilText = docSnapshot.data()?['stadtviertelText'] ?? 'No data';
        zeitText = docSnapshot.data()?['zeitText'] ?? 'No data';
        bezahlungText = docSnapshot.data()?['bezahlungText'] ?? 'No data';
        kontaktText = docSnapshot.data()?['kontaktText'] ?? 'No data';
      await _notesServiceAngebote.updateNoteAngebote(
        documentId: documentId,
        textJob: jobText,
        textAdresse: adresseText,
        textBezahlung: stadtText,
        textKontakt: kontaktText,
        textZeit: zeitText,
        textStadt: stadtText,
        textStadtviertel: stadtteilText,
        deletionTime: DateTime.now().add(const Duration(days: 14)),
      );
    }else{
      var collection = FirebaseFirestore.instance.collection('notes');
      var docSnapshot = await collection.doc(documentId).get();
      jobText = docSnapshot.data()?['jobText'] ?? 'No data';
        adresseText = docSnapshot.data()?['adresseText'] ?? 'No data';
        stadtText = docSnapshot.data()?['stadtText'] ?? 'No data';
        stadtteilText = docSnapshot.data()?['stadtviertelText'] ?? 'No data';
        zeitText = docSnapshot.data()?['zeitText'] ?? 'No data';
        bezahlungText = docSnapshot.data()?['bezahlungText'] ?? 'No data';
        kontaktText = docSnapshot.data()?['kontaktText'] ?? 'No data';
      await _notesService.updateNote(
        documentId: documentId,
        textJob: jobText,
        textAdresse: adresseText,
        textBezahlung: stadtText,
        textKontakt: kontaktText,
        textZeit: zeitText,
        textStadt: stadtText,
        textStadtviertel: stadtteilText,
        deletionTime: DateTime.now().add(const Duration(days: 14)),
      );
    }
  }

  Future<bool> isAngebot(documentId) async {
    bool isAngebot = true;
    var angebot = '';
    var collection = FirebaseFirestore.instance.collection('notes');
    var docSnapshot = await collection.doc(documentId).get();
    var collectionAngebote =
        FirebaseFirestore.instance.collection('notesAngebote');
    if (docSnapshot.exists) {
      angebot = docSnapshot.data()?['angebotText'];
    } else {
      docSnapshot = await collectionAngebote.doc(documentId).get();
      angebot = docSnapshot.data()?['angebotText'];
    }
    if (angebot == 'noteNotAngebot') {
      isAngebot = false;
    } else if (angebot == 'noteAngebot') {
      isAngebot = true;
    } else {}
    return isAngebot;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);

        return ListTile(
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.textJob,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: FutureBuilder(
                future: isUserAuthor(note.documentId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    isAngebot(note.documentId);
                    bool isvisible = snapshot.data as bool;

                    return Visibility(
                      visible: isvisible,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final shouldReset = await showResetDeletionDialog(
                                  context, note.documentId);
                              if (shouldReset == 'reset') {
                                resetDeletiontimerFunction(note.documentId);
                              }else {
                              }
                            },
                            icon: const Icon(Icons.hourglass_bottom_rounded),
                          ),
                          IconButton(
                            onPressed: () async {
                              final shouldDelete =
                                  await showDeleteDialog(context);
                              final isAngebote =
                                  await isAngebot(note.documentId);
                              if (isAngebote == true) {
                                if (shouldDelete == true) {
                                  _notesServiceAngebote.deleteNoteAngebote(
                                      documentId: note.documentId);
                                }
                              } else if (isAngebote == false) {
                                if (shouldDelete == true) {
                                  _notesService.deleteNote(
                                      documentId: note.documentId);
                                }
                              }
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.amber,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }));
      },
    );
  }
}
