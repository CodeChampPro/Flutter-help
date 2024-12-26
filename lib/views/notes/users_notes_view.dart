// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:mynotes/views/notes/notes_list_view_angebote.dart';
import 'package:rxdart_ext/not_replay_value_stream.dart';

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

  final notes = FirebaseFirestore.instance.collection('notes');
  final notesAngebote = FirebaseFirestore.instance.collection('notesAngebote');
  late final Stream <Iterable<CloudNote>>notesStream;
  late final Stream <Iterable<CloudNote>>notesAngeboteStream;
  late final Stream<Iterable<CloudNote>> mergedStream;
  @override
  void initState() {
    notesStream = allNotesUser();
    notesAngeboteStream = allNotesUserAngebote();
    mergedStream= Rx.combineLatest2(
      notesStream,
      notesAngeboteStream,
      (Iterable<CloudNote> notes, Iterable<CloudNote> notesAngebote) =>
          notes.followedBy(notesAngebote),);
    super.initState();
  }


  

  

  Stream<Iterable<CloudNote>> allNotesUserAngebote() {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final allNotes = notesAngebote
        .where('user_id', isEqualTo: currentUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  Stream<Iterable<CloudNote>> allNotesUser() {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final allNotes = notes
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
          title: const Text('Your Requests'),
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
        body: StreamBuilder<Iterable<CloudNote>>
        (
          stream: mergedStream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes:allNotes,
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
