// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';


class EditNotesView extends StatefulWidget {
  final String documentId;
  const EditNotesView({Key? key, required this.documentId}) : super(key: key);

  @override
  EditNotesViewState createState() => EditNotesViewState();
}

class EditNotesViewState extends State<EditNotesView> {
   CloudNote? _note;
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

  late final FirebaseCloudStorage _notesService;
  TextEditingController _adresseController = TextEditingController();
  TextEditingController _zeitController = TextEditingController();
  TextEditingController _bezahlungController = TextEditingController();
  TextEditingController _kontaktController = TextEditingController();
  TextEditingController _stadtController = TextEditingController();
  TextEditingController _stadtviertelController = TextEditingController();

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _adresseController = TextEditingController();
    _zeitController = TextEditingController();
    _bezahlungController = TextEditingController();
    _kontaktController = TextEditingController();
    _stadtController = TextEditingController();
    _stadtviertelController = TextEditingController();
    fetchNoteData(widget.documentId);
    
    super.initState();
  }

  void showPopupMenu(BuildContext context) async {
    result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Babysitting'),
              onTap: () {
                Navigator.pop(context, 'Babysitting');
              },
            ),
            ListTile(
              title: const Text('Nachhilfe'),
              onTap: () {
                Navigator.pop(context, 'Nachhilfe');
              },
            ),
            ListTile(
              title: const Text('Rasenmähen'),
              onTap: () {
                Navigator.pop(context, 'Rasenmähen');
              },
            ),
            ListTile(
              title: const Text('Andere'),
              onTap: () {
                Navigator.pop(context, 'Andere');
              },
            ),
          ],
        );
      },
    );

    if (result == 'Andere') {
      String? enteredOption = await showDialog(
        context: context,
        builder: (BuildContext context) {
          String enteredOption = '';
          return AlertDialog(
            title: const Text('Benutzerdefinierte Option eingeben'),
            content: TextField(
              onChanged: (value) {
                enteredOption = value;
              },
              decoration: const InputDecoration(
                hintText: 'Geben Sie hier Ihre Option ein',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, null); // Cancel button
                },
                child: const Text('Abbrechen'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, enteredOption); // OK button
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (enteredOption != null) {
        setState(() {
          selectedOption = enteredOption;
        });
      }
    } else {
      setState(() {
        selectedOption = result;
      });
    }
  }

  void showPopupMenuStadt(BuildContext context) async {
    selectedOptionStadt = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('München'),
              onTap: () {
                Navigator.pop(context, 'München');
              },
            ),
            ListTile(
              title: const Text('Stutgart'),
              onTap: () {
                Navigator.pop(context, 'Stutgart');
              },
            ),
            ListTile(
              title: const Text('Berlin'),
              onTap: () {
                Navigator.pop(context, 'Berlin');
              },
            ),
            ListTile(
              title: const Text('Hamburg'),
              onTap: () {
                Navigator.pop(context, 'Hamburg');
              },
            ),
          ],
        );
      },
    );
    setState(() {
      
    });
    
    }
   void showPopupMenuStadtteil(BuildContext context) async {
    selectedOptionStadtteil = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Bogenhausen'),
              onTap: () {
                Navigator.pop(context, 'Bogenhausen');
              },
            ),
            ListTile(
              title: const Text('Haidhausen'),
              onTap: () {
                Navigator.pop(context, 'Haidhausen');
              },
            ),
            ListTile(
              title: const Text('Schwabing'),
              onTap: () {
                Navigator.pop(context, 'Schwabing');
              },
            ),
            ListTile(
              title: const Text('Laim'),
              onTap: () {
                Navigator.pop(context, 'Laim');
              },
            ),
            ListTile(
              title: const Text('Lehel'),
              onTap: () {
                Navigator.pop(context, 'Lehel');
              },
            ),
            ListTile(
              title: const Text('Maxvorstadt'),
              onTap: () {
                Navigator.pop(context, 'Maxvorstadt');
              },
            ),
            ListTile(
              title: const Text('Sendling'),
              onTap: () {
                Navigator.pop(context, 'Sendling');
              },
            ),
            ListTile(
              title: const Text('Passing'),
              onTap: () {
                Navigator.pop(context, 'Passing');
              },
            ),
            
          ],
        );
      },
    );
    setState(() {
      
    });
    
    }

 void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final textAdresse = _adresseController.text;
    final textZeit = _zeitController.text;
    final textStadt = selectedOptionStadt;
    final textStadtviertel = selectedOptionStadtteil;
    final textBezahlung = _bezahlungController.text;
    final textKontakt = _kontaktController.text;
    final textJob = selectedOption;
    await _notesService.updateNote(
      documentId: note.documentId,
      textAdresse: textAdresse,
      textStadt: textStadt,
      textStadtviertel: textStadtviertel,
      textJob: textJob,
      textBezahlung: textBezahlung,
      textKontakt: textKontakt,
      textZeit: textZeit,
    );
  }
  void _setupTextControllerListener() {
    _adresseController.removeListener(_textControllerListener);
    _adresseController.addListener(_textControllerListener);
    _zeitController.removeListener(_textControllerListener);
    _zeitController.addListener(_textControllerListener);
    _kontaktController.removeListener(_textControllerListener);
    _kontaktController.addListener(_textControllerListener);
    _bezahlungController.removeListener(_textControllerListener);
    _bezahlungController.addListener(_textControllerListener);
    _stadtController.removeListener(_textControllerListener);
    _stadtController.addListener(_textControllerListener);
    _stadtviertelController.removeListener(_textControllerListener);
    _stadtviertelController.addListener(_textControllerListener);
  }

  Future<void> fetchNoteData(String documentId) async {
    var collection = FirebaseFirestore.instance.collection('notes');
    var docSnapshot = await collection.doc(documentId).get();
    if (docSnapshot.exists) {
      setState(() {
        jobText = docSnapshot.data()?['jobText'] ?? 'No data';
        adresseText = docSnapshot.data()?['adresseText'] ?? 'No data';
        stadtText = docSnapshot.data()?['stadtText'] ?? 'No data';
        stadtteilText = docSnapshot.data()?['stadtviertelText'] ?? 'No data';
        zeitText = docSnapshot.data()?['zeitText'] ?? 'No data';
        bezahlungText = docSnapshot.data()?['bezahlungText'] ?? 'No data';
        kontaktText = docSnapshot.data()?['kontaktText'] ?? 'No data';
      });
    } else {
      setState(() {
        jobText = 'Document not found';
        adresseText = 'Document not found';
        stadtText = 'Document not found';
        stadtteilText = 'Document not found';
        kontaktText = 'Document not found';
        bezahlungText = 'Document not found';
        zeitText = 'Document not found';

      });
    }
    selectedOptionStadt = stadtText;
    selectedOptionStadtteil = stadtteilText;
    _adresseController.text = adresseText;
    _zeitController.text = zeitText;
    _bezahlungController.text = bezahlungText;
    _kontaktController.text = kontaktText;
    selectedOption = jobText;
  }

   void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_adresseController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty(String documentId) async {
    
    final textAdresse = _adresseController.text;
    final textStadt = selectedOptionStadt;
    final textStadtviertel = selectedOptionStadtteil;
    final textZeit = _zeitController.text;
    final textBezahlung = _bezahlungController.text;
    final textKontakt = _kontaktController.text;
    final textJob = selectedOption;
    if ( textAdresse.isNotEmpty && textJob.isNotEmpty) {
      await _notesService.updateNote(
        documentId: documentId,
        textAdresse: textAdresse,
        textJob: textJob,
        textBezahlung: textBezahlung,
        textKontakt: textKontakt,
        textZeit: textZeit,
        textStadt: textStadt,
        textStadtviertel: textStadtviertel,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty('');
    _adresseController.dispose();
    _kontaktController.dispose();
    _zeitController.dispose();
    _bezahlungController.dispose();
    _stadtController.dispose();
    _stadtviertelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setupTextControllerListener();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Colors.green.shade200,
        actions: [
          IconButton(
            onPressed: ()  {
              _saveNoteIfTextNotEmpty(widget.documentId);
             Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const NotesView()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body:FutureBuilder(
        future: fetchNoteData(''),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              _saveNoteIfTextNotEmpty(widget.documentId);

              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showPopupMenu(context);
                    },
                    child: Text(selectedOption),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () {
                    showPopupMenuStadt(context);
                  }, child: Text(selectedOptionStadt)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () {
                    showPopupMenuStadtteil(context);
                  }, child: Text(selectedOptionStadtteil)),
                  TextField(
                    controller: _zeitController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Geben sie an wann und wie oft der Job gemacht werden soll.',
                    ),
                  ),
                  
                  TextField(
                    controller: _adresseController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Geben sie an wo der Job ausgeführt werden soll.',
                    ),
                  ),
                  TextField(
                    controller: _bezahlungController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Geben sie an was sie sich als bezahlung vorstellen könnten.',
                    ),
                  ),
                  TextField(
                    controller: _kontaktController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Geben sie daten zum Kontaktieren an.',
                    ),
                  ),
                ],
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
    