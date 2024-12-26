// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage_angebote.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorageAngebote _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  bool isInputVisible = false;
  TextEditingController _textEditingController = TextEditingController();
  String searchResult = 'Nachhilfe';
  late bool? isChecked1;
  late bool? isChecked2;
  late bool? isChecked3;
  late bool? isChecked4;
  late bool? isChecked5;
  late bool? isChecked6;
  late bool? isChecked7;
  late bool? isChecked8;
  late String filterResult1;
  late String filterResult2;
  late String filterResult3;
  late String filterResult4;
  late String filterResult5;
  late String filterResult6;
  late String filterResult7;
  late String filterResult8;
  late bool? isSomethingChecked;
  late List<CloudNote> notesList;
  late List<CloudNote> notesList2;
  late List<CloudNote> notesList3;

  final notes = FirebaseFirestore.instance.collection('notesAngebote');

  @override
  void initState() {
    _notesService = FirebaseCloudStorageAngebote();
    _textEditingController = TextEditingController();
    _setupTextControllerListener();
    HardwareKeyboard.instance.addHandler(_onKeyEvent);
    isChecked1 = false;
    isChecked2 = false;
    isChecked3 = false;
    isChecked5 = false;
    isChecked6 = false;
    isChecked7 = false;
    isChecked8 = false;
    isChecked4 = false;
    filterResult1 = '';
    filterResult2 = '';
    filterResult3 = '';
    filterResult4 = '';
    filterResult5 = '';
    filterResult6 = '';
    filterResult7 = '';
    filterResult8 = '';
    isSomethingChecked = false;
    notesList = [];

    super.initState();
  }

  void _textControllerListener() async {
    final suche = _textEditingController.text;
  }

  void _setIsSomethingChecked() {
    if (isChecked1 == true || isChecked2 == true || isChecked3 == true) {
      isSomethingChecked = true;
    } else {
      isSomethingChecked = false;
    }
  }

  void deleteOldNotes(
    Iterable<CloudNote> notes,
  ) async {
    for (final note in notes) {
      final dateToCheck = note.deletionTime.toDate();
      if (dateToCheck.isBefore(DateTime.now())) {
        
        await _notesService.deleteNoteAngebote(documentId: note.documentId);
      } else {
        
      }
    }
  }


 bool _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      searchResult = _textEditingController.text;
      setState(() {
        isInputVisible = false;
      });
      return true; 
    }
    return false;
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    HardwareKeyboard.instance.removeHandler(_onKeyEvent);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
            stream: _notesService.allNotesAngebote(''),
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
            PopupMenuButton<int>(
              icon: const Icon(Icons.filter_list),
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    value: 0,
                    child: StatefulBuilder(builder: (context, innerSetState) {
                      return SingleChildScrollView(
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text(
                                  'select Filters',
                                  style: TextStyle(fontSize: 20),
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                    'Bogenhausen',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: isChecked1,
                                  onChanged: (bool? newValue) {
                                    innerSetState(() {
                                      isChecked1 = newValue;
                                      _setIsSomethingChecked();
                                      if (filterResult1 == '') {
                                        filterResult1 = 'Bogenhausen';
                                      } else {
                                        filterResult1 = '';
                                      }
                                    });
                                    setState(() {
                                      isChecked1 = newValue;
                                    });
                                  },
                                  activeColor: Colors.amber.shade600,
                                  checkColor: Colors.black,
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                    'Haidhausen',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: isChecked2,
                                  onChanged: (bool? newValue) {
                                    innerSetState(() {
                                      isChecked2 = newValue;
                                      _setIsSomethingChecked();
                                      if (filterResult2 == '') {
                                        filterResult2 = 'Haidhausen';
                                      } else {
                                        filterResult2 = '';
                                      }
                                    });
                                    setState(() {
                                      isChecked2 = newValue;
                                    });
                                  },
                                  activeColor: Colors.amber.shade600,
                                  checkColor: Colors.black,
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                    'Schwabing',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: isChecked3,
                                  onChanged: (bool? newValue) {
                                    innerSetState(() {
                                      isChecked3 = newValue;
                                      _setIsSomethingChecked();
                                      if (filterResult3 == '') {
                                        filterResult3 = 'Schwabing';
                                      } else {
                                        filterResult3 = '';
                                      }
                                    });
                                    setState(() {
                                      isChecked3 = newValue;
                                    });
                                  },
                                  activeColor: Colors.amber.shade600,
                                  checkColor: Colors.black,
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                    'Lehel',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: isChecked4,
                                  onChanged: (bool? newValue) {
                                    innerSetState(() {
                                      isChecked4 = newValue;
                                      _setIsSomethingChecked();
                                      if (filterResult4 == '') {
                                        filterResult4 = 'Lehel';
                                      } else {
                                        filterResult4 = '';
                                      }
                                    });
                                    setState(() {
                                      isChecked4 = newValue;
                                    });
                                  },
                                  activeColor: Colors.amber.shade600,
                                  checkColor: Colors.black,
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                    'Maxvorstadt',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: isChecked5,
                                  onChanged: (bool? newValue) {
                                    innerSetState(() {
                                      isChecked5 = newValue;
                                      _setIsSomethingChecked();
                                      if (filterResult5 == '') {
                                        filterResult5 = 'Maxvorstadt';
                                      } else {
                                        filterResult5 = '';
                                      }
                                    });
                                    setState(() {
                                      isChecked5 = newValue;
                                    });
                                  },
                                  activeColor: Colors.amber.shade600,
                                  checkColor: Colors.black,
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                    'Sendling',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: isChecked6,
                                  onChanged: (bool? newValue) {
                                    innerSetState(() {
                                      isChecked6 = newValue;
                                      _setIsSomethingChecked();
                                      if (filterResult6 == '') {
                                        filterResult6 = 'Sendling';
                                      } else {
                                        filterResult6 = '';
                                      }
                                    });
                                    setState(() {
                                      isChecked6 = newValue;
                                    });
                                  },
                                  activeColor: Colors.amber.shade600,
                                  checkColor: Colors.black,
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                    'Pasing',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: isChecked7,
                                  onChanged: (bool? newValue) {
                                    innerSetState(() {
                                      isChecked2 = newValue;
                                      _setIsSomethingChecked();
                                      if (filterResult7 == '') {
                                        filterResult7 = 'Pasing';
                                      } else {
                                        filterResult7 = '';
                                      }
                                    });
                                    setState(() {
                                      isChecked7 = newValue;
                                    });
                                  },
                                  activeColor: Colors.amber.shade600,
                                  checkColor: Colors.black,
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                    'Laim',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: isChecked8,
                                  onChanged: (bool? newValue) {
                                    innerSetState(() {
                                      isChecked8 = newValue;
                                      _setIsSomethingChecked();
                                      if (filterResult8 == '') {
                                        filterResult8 = 'Laim';
                                      } else {
                                        filterResult8 = '';
                                      }
                                    });
                                    setState(() {
                                      isChecked8 = newValue;
                                    });
                                  },
                                  activeColor: Colors.amber.shade600,
                                  checkColor: Colors.black,
                                ),
                                TextButton(
                                    onPressed: () {
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: const Text('apply'))
                              ],
                            )),
                      );
                    }),
                  ),
                ];
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isInputVisible = !isInputVisible;
                });
              },
            ),
            Visibility(
              visible: isInputVisible,
              child: Container(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(createUpdateNoteViewAngeboteRoute, (route) => false);
              },
              icon: const Icon(Icons.add),
            ),
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
          stream: _notesService.allNotesAngebote(searchResult),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  deleteOldNotes(allNotes);
                  final filteredNotes = sortNotesFilter(
                    allNotes,
                    filterResult1,
                    filterResult2,
                    filterResult3,
                    filterResult4,
                    filterResult5,
                    filterResult6,
                    filterResult7,
                    filterResult8,
                    isSomethingChecked,
                  );
                  final sortedNotes = sortNotes(filteredNotes, searchResult);
                  return NotesListView(
                    notes: sortedNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNoteAngebote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        showNotesAngeboteRoute,
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
              label: 'I need ...',
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
                Navigator.of(context).pushNamedAndRemoveUntil(
                    usersNotesRoute, (route) => false);
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
