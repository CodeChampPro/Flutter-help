import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage_angebote.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';
import 'package:mynotes/utilities/generics/is_user_author_angebote.dart';

typedef NoteCallback = void Function(CloudNote note);
final _notesService = FirebaseCloudStorageAngebote();
class NotesListViewAngebote extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListViewAngebote({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

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
                future: isUserAuthorAngebote(note.documentId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    bool isvisible = snapshot.data as bool;
                    return Visibility(
                      visible: isvisible,
                      child: IconButton( 
                        onPressed: () async {
                          final shouldDelete = await showDeleteDialog(context);
                          if (shouldDelete==true) {
                            _notesService.deleteNoteAngebote(documentId: note.documentId);
                          }else{
                            
                          }
                        },
                        icon: const Icon(Icons.delete),
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
