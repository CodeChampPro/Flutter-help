// ignore_for_file: sized_box_for_whitespace

import 'dart:async';

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
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({
    Key? key,
  }) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  List<String> filterResultsFinal = [];
  bool isScrollViewVisible = false;
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  bool isInputVisible = false;
  RelativeRect? popupMenuPosition;
  TextEditingController _textEditingController = TextEditingController();
  String searchResult = 'Nachhilfe';
  List<String> filterResults = [];
  late bool? isChecked1;
  late bool? isChecked2;
  late bool? isChecked3;
  late bool? isChecked4;
  late bool? isChecked5;
  late bool? isChecked6;
  late bool? isChecked7;
  late bool? isChecked8;
  late bool? isChecked9;
  late bool? isChecked10;
  late bool? isChecked11;
  late bool? isChecked12;
  late bool? isChecked13;
  late bool? isChecked14;
  late bool? isChecked15;

  late String filterResult1;
  late String filterResult2;
  late String filterResult3;
  late String filterResult4;
  late String filterResult5;
  late String filterResult6;
  late String filterResult7;
  late String filterResult8;
  late String filterResult9;
  late String filterResult10;
  late String filterResult11;
  late String filterResult12;
  late String filterResult13;
  late String filterResult14;
  late String filterResult15;
  bool isSomethingChecked = false;
  late List<CloudNote> notesList;
  late List<CloudNote> notesList2;
  late List<CloudNote> notesList3;

  List<String> stadtteileAuswahl = [];
  String stadtGewealt = '';
  List<Map> stadtAuswahl = [
    {"name": "München", "isChecked": false},
    {"name": "Stutgart", "isChecked": false},
    {"name": "Berlin", "isChecked": false},
    {"name": "Hamburg", "isChecked": false},
  ];

  List<String> hamburg = [
    'Altstadt',
    'Neustadt',
    'St. Pauli',
    'Sternschanze',
    'Eimsbüttel',
    'Altona',
    'Ottensee',
    'Haffencity',
    'Winterhude',
    'Blankensee',
  ];

  List<String> muenchen = [
    'Sendling',
    'Bogenhausen',
    'Haidhausen',
    'Schwabing',
    'Ried',
    'Lehel',
    'Pasing',
  ];

  List<String> berlin = [
    'Mitte',
    'Kreuzberg',
    'Penzlauer Berg',
    'Charlottenburg',
    'Friedrichshain',
    'Neukölln',
    'Schöneberg',
    'Wedding',
    'Tiergarten',
    'Steglitz-Zehlendorf',
  ];

  List<String> stutgart = [
    'Mitte',
    'Bad Cannstatt',
    'Vaihingen',
    'Feuerbach',
    'Degerloch',
    'Zuffenhausen',
    'Sillenbruch',
    'Möhringen',
    'Ostheim',
    'West',
  ];

  final notes = FirebaseFirestore.instance.collection('notes');

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textEditingController = TextEditingController();
    _setupTextControllerListener();
    filterResultsFinal = [];

    HardwareKeyboard.instance.addHandler(_onKeyEvent);
    isChecked1 = false;
    isChecked2 = false;
    isChecked3 = false;
    isChecked4 = false;
    isChecked5 = false;
    isChecked6 = false;
    isChecked7 = false;
    isChecked8 = false;
    isChecked9 = false;
    isChecked10 = false;
    isChecked11 = false;
    isChecked12 = false;
    isChecked13 = false;
    isChecked14 = false;
    isChecked15 = false;

    filterResult1 = '';
    filterResult2 = '';
    filterResult3 = '';
    filterResult4 = '';
    filterResult5 = '';
    filterResult6 = '';
    filterResult7 = '';
    filterResult8 = '';
    filterResult9 = '';
    filterResult10 = '';
    filterResult11 = '';
    filterResult12 = '';
    filterResult13 = '';
    filterResult14 = '';
    filterResult15 = '';

    
    notesList = [];

    super.initState();
  }
  
  void _textControllerListener() async {
    final suche = _textEditingController.text;
  }

  void deleteOldNotes(
    Iterable<CloudNote> notes,
  ) async {
    for (final note in notes) {
      final dateToCheck = note.deletionTime.toDate();
      if (dateToCheck.isBefore(DateTime.now())) {
        await _notesService.deleteNote(documentId: note.documentId);
      } else {}
    }
  }

  void filterFunktion() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Container(
                        width: 220,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.green.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Ensures the dialog is as small as needed
                              children: [
                                for (var favourite in stadtAuswahl)
                                  CheckboxListTile(
                                    checkboxShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    activeColor: Colors.green.shade800,
                                    title: Text(favourite['name']),
                                    value: favourite['isChecked'],
                                    onChanged: (val) {
                                      setState(() {
                                        for (var stadt in stadtAuswahl) {
                                          stadt['isChecked'] = false;
                                        }
                                        favourite['isChecked'] = val;
                                      });
                                    },
                                  ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        for (var stadt in stadtAuswahl) {
                                          if (stadt['isChecked'] == true) {
                                            stadtGewealt = stadt['name'];
                                          }
                                        }
                                        if (stadtGewealt == 'Hamburg') {
                                          stadtteileAuswahl = hamburg;
                                        } else if (stadtGewealt == 'München') {
                                          stadtteileAuswahl = muenchen;
                                        } else if (stadtGewealt == 'Berlin') {
                                          stadtteileAuswahl = berlin;
                                        } else if (stadtGewealt == 'Stutgart') {
                                          stadtteileAuswahl = stutgart;
                                        }
                                        Navigator.of(context).pop();
                                        showSecondPopupMenu(
                                            context, stadtteileAuswahl);
                                      },
                                      child: const Text('Next'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        isSomethingChecked = false;
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Reset'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            ),
          ),
        );
      },
    );
  }
 
  Future<List<String>> showSecondPopupMenu(
      BuildContext context, List<String> items) async {
    // Compute the position dynamically based on current widget location
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    // Define the position for the second popup  fjdsal      fa  print('')
    RelativeRect position = RelativeRect.fromLTRB(
        offset.dx,
        offset.dy, // position below the widget
        offset.dx,
        offset.dy);

    List<bool> isChecked = List<bool>.filled(items.length, false);
    List<String> filterResults = List<String>.filled(items.length, '');
    Completer<List<String>> completer = Completer<List<String>>();

    showDialog(
      context: context,
      barrierDismissible: true, // Allows closing the dialog by tapping outside
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 220,
                    height: 350, // Set a smaller width for the dialog
                    decoration: BoxDecoration(
                      color: Colors.green.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize
                                .min, // Ensures the dialog is as small as needed
                            children: [
                              for (int i = 0; i < items.length; i++)
                                CheckboxListTile(
                                  title: Text(items[i]),
                                  value: isChecked[i],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked[i] = value ?? false;
                                      filterResults[i] = value! ? items[i] : '';
                                    });
                                  },
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  activeColor: Colors.green.shade800,
                                  checkColor: Colors.white,
                                ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    filterResultsFinal = filterResults
                                        .where((element) => element.isNotEmpty)
                                        .toList();
                                    
                                    print('f');

                                    
                                    setState(() {
                                      searchResult = 'Babysitting';
                                      isSomethingChecked = true;
                                    });
                                    
                                  }
                                  );
                                  
                                  completer.complete(filterResultsFinal);
                                  Navigator.pop(context);
                                },
                                child: const Text('Apply'),
                              ),
                            ],
                          ),
                        )),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    return completer.future;
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
    print('s');
    return Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
            stream: _notesService.allNotes(''),
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
            
            IconButton(
                onPressed: () {
                  filterFunktion();
                },
                icon: const Icon(Icons.filter)),
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
                Navigator.of(context).pushNamedAndRemoveUntil(
                    createOrUpdateNoteRoute, (route) => false);
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
          stream: _notesService.allNotes(searchResult,),
          
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  print('h');
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  deleteOldNotes(allNotes);

                  // Referencing `filterResultsFinal` to apply dynamic filtering
                  filterResult1 = filterResultsFinal.isNotEmpty
                      ? filterResultsFinal[0]
                      : '';
                  filterResult2 = filterResultsFinal.length > 1
                      ? filterResultsFinal[1]
                      : '';
                  filterResult3 = filterResultsFinal.length > 2
                      ? filterResultsFinal[2]
                      : '';
                  filterResult4 = filterResultsFinal.length > 3
                      ? filterResultsFinal[3]
                      : '';
                  filterResult5 = filterResultsFinal.length > 4
                      ? filterResultsFinal[4]
                      : '';
                  filterResult6 = filterResultsFinal.length > 5
                      ? filterResultsFinal[5]
                      : '';
                  filterResult7 = filterResultsFinal.length > 6
                      ? filterResultsFinal[6]
                      : '';
                  filterResult8 = filterResultsFinal.length > 7
                      ? filterResultsFinal[7]
                      : '';
                  filterResult9 = filterResultsFinal.length > 8
                      ? filterResultsFinal[8]
                      : '';
                  filterResult10 = filterResultsFinal.length > 9
                      ? filterResultsFinal[9]
                      : '';

                  // Apply the filters and get the filtered list of notes
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
                    filterResult9,
                    filterResult10,
                    isSomethingChecked,
                  );

                  // Sort notes based on search criteria
                  final sortedNotes = sortNotes(filteredNotes, searchResult);

                  return NotesListView(
                    notes: sortedNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        showNotesRoute,
                        arguments: note.documentId,
                      );
                    },
                  );
                } else {
                  print('l  ');
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
    String filterResult9,
    String filterResult10,
    bool? isSomethingChecked) {
  final List<CloudNote> specificValueNotesFilter = [];
  final List<CloudNote> otherNotesFilter = [];
  if (isSomethingChecked == true) {
    print('d');

    for (final note in notes) {
      if (note.textStadtviertel == filterResult1 ||
          note.textStadtviertel == filterResult2 ||
          note.textStadtviertel == filterResult3 ||
          note.textStadtviertel == filterResult4 ||
          note.textStadtviertel == filterResult5 ||
          note.textStadtviertel == filterResult6 ||
          note.textStadtviertel == filterResult7 ||
          note.textStadtviertel == filterResult10 ||
          note.textStadtviertel == filterResult9 ||
          note.textStadtviertel == filterResult8) {
        specificValueNotesFilter.add(note);
      } else {
        otherNotesFilter.add(note);
      }
    }
  // fd  afd  f  if the zurich has the nw(){doasf afd  asf } fo i in notes(i= i+1) for the worst  can i have the new found luck because i have had the newest invention in years
  //xbut i ca have the most luck because i have foole d hmm and i () { but i cannot havr }  dkfja  földask jfölajf akdjf for I in range 10 ()dskjf h
  // when i have another way of speaking i can but if i have a i want to djf a f(){ fo print(but if i have tfor ling this will suck o )}
    return [
      ...specificValueNotesFilter,
    ];
  } else {
    print('i');
    return notes;
  }
}
