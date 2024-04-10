// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage_angebote.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class UsersNotesView extends StatefulWidget {
  const UsersNotesView({Key? key}) : super(key: key);

  @override
  _UsersNotesViewState createState() => _UsersNotesViewState();
}

class _UsersNotesViewState extends State<UsersNotesView> {
  String get userId => AuthService.firebase().currentUser!.id;

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  final notesAngeboteCollection =
      FirebaseFirestore.instance.collection('notesAngebote');
  final notesCollection = FirebaseFirestore.instance.collection('notes');
  List<Map<String, dynamic>> allNotes = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> mergeCollections() async {
    QuerySnapshot notesAngeboteSnapshot = await notesAngeboteCollection.get();

    QuerySnapshot notesSnapshot = await notesCollection.get();

    allNotes.addAll(notesAngeboteSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>));

    allNotes.addAll(
        notesSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>));

    return allNotes;
  }

  Stream<Iterable<CloudNote>> allNotesUser() {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final allNotes = notesAngeboteCollection
        .where('user_id', isEqualTo: currentUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
            stream: allNotesUser(),
            builder: (context, AsyncSnapshot<Iterable<CloudNote>> snapshot) {
              if (snapshot.hasData) {
                return const Text('Aufträge');
              } else {
                return const Text('');
              }
            },
          ),
          backgroundColor: Colors.green.shade200,
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    }
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text(context.loc.logout_button),
                  ),
                ];
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: allNotesUser(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;

                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {},
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        showNotesRoute,
                        arguments: note.documentId,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'I need...',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'My Displays',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'I want to do ...',
            ),
          ],
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(notesViewRoute, (route) => false);
                break;
              case 1:
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(usersNotesRoute, (route) => false);
                break;
              case 2:
                Navigator.of(context).pushNamedAndRemoveUntil(
                    notesViewAngeboteRoute, (route) => false);
                break;
            }
          },
        ));
  }
}

Iterable<CloudNote> sortNotes(Iterable<CloudNote> notes, String searchResult) {
  final List<CloudNote> specificValueNotes = [];
  final List<CloudNote> otherNotes = [];
  final hi = searchResult;

  for (final note in notes) {
    if (note.textJob == hi) {
      specificValueNotes.add(note);
    } else {
      otherNotes.add(note);
    }
  }

  return [...specificValueNotes, ...otherNotes];
}

Iterable<CloudNote> sortNotesFilter(
    Iterable<CloudNote> notes,
    String filterResult1,
    String filterResult2,
    String filterResult3,
    String filterResult4,
    String filterResult5,
    String filterResult6,
    String filterResult7,
    String filterResult8,
    bool? isSomethingChecked) {
  final List<CloudNote> specificValueNotesFilter = [];
  final List<CloudNote> otherNotesFilter = [];

  if (isSomethingChecked == true) {
    for (final note in notes) {
      if (note.textStadtviertel == filterResult1 ||
          note.textStadtviertel == filterResult2 ||
          note.textStadtviertel == filterResult3 ||
          note.textStadtviertel == filterResult4 ||
          note.textStadtviertel == filterResult5 ||
          note.textStadtviertel == filterResult6 ||
          note.textStadtviertel == filterResult7 ||
          note.textStadtviertel == filterResult8) {
        specificValueNotesFilter.add(note);
      } else {
        otherNotesFilter.add(note);
      }
    }
    filterResult1 = '';
    filterResult2 = '';
    filterResult3 = '';
    filterResult4 = '';
    filterResult5 = '';
    filterResult6 = '';
    filterResult7 = '';
    filterResult8 = '';

    return [
      ...specificValueNotesFilter,
    ];
  } else {
    return notes;
  }
}
