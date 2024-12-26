// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage_angebote.dart';
import 'package:mynotes/utilities/dialogs/automatic_delete_dialog.dart';

class CreateUpdateNoteViewAngebote extends StatefulWidget {
  const CreateUpdateNoteViewAngebote({Key? key}) : super(key: key);

  @override
  _CreateUpdateNoteViewAngeboteState createState() =>
      _CreateUpdateNoteViewAngeboteState();
}

class _CreateUpdateNoteViewAngeboteState
    extends State<CreateUpdateNoteViewAngebote> {
  CloudNote? _note;
  var selectedOption = 'Choose what you want to do';
  var result = '';
  var selectedOptionStadtAngebote = 'In which city do you live?';
  var selectedOptionStadtteilAngebote = 'In district do you live?';
  late final FirebaseCloudStorageAngebote _notesService;
  TextEditingController _adresseController = TextEditingController();
  TextEditingController _zeitController = TextEditingController();
  TextEditingController _bezahlungController = TextEditingController();
  TextEditingController _kontaktController = TextEditingController();
  TextEditingController _stadtController = TextEditingController();
  TextEditingController _stadtviertelController = TextEditingController();

  @override
  void initState() {
    _notesService = FirebaseCloudStorageAngebote();
    _adresseController = TextEditingController();
    _zeitController = TextEditingController();
    _bezahlungController = TextEditingController();
    _kontaktController = TextEditingController();
    _stadtController = TextEditingController();
    _stadtviertelController = TextEditingController();
    super.initState();
  }

  void showPopupMenuJob(BuildContext context) async {
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
              title: const Text('Tutoring'),
              onTap: () {
                Navigator.pop(context, 'Tutoring');
              },
            ),
            ListTile(
              title: const Text('Lawnmoaing'),
              onTap: () {
                Navigator.pop(context, 'Lawnmoaing');
              },
            ),
            ListTile(
              title: const Text('other'),
              onTap: () {
                Navigator.pop(context, 'other');
              },
            ),
          ],
        );
      },
    );

    if (result == 'other') {
      String? enteredOption = await showDialog(
        context: context,
        builder: (BuildContext context) {
          String enteredOption = '';
          return AlertDialog(
            title: const Text('choose your own'),
            content: TextField(
              onChanged: (value) {
                enteredOption = value;
              },
              decoration: const InputDecoration(
                hintText: 'what do you want to do?',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, null); // Cancel button
                },
                child: const Text('Cancel'),
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
    selectedOptionStadtAngebote = await showModalBottomSheet(
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
    setState(() {});
  }


  void showPopupMenuStadtteil(
  BuildContext context,
  String stadtteil1,
  String stadtteil2,
  String stadtteil3,
  String stadtteil4,
  String stadtteil5,
  String stadtteil6,
  String stadtteil7,
  String stadtteil8,
  String stadtteil9,
  String stadtteil10
) async {
  // Create a list of non-empty stadtteil parameters
  List<String> stadtteile = [
    stadtteil1,
    stadtteil2,
    stadtteil3,
    stadtteil4,
    stadtteil5,
    stadtteil6,
    stadtteil7,
    stadtteil8,
    stadtteil9,
    stadtteil10
  ].where((stadtteil) => stadtteil.isNotEmpty).toList();

  selectedOptionStadtteilAngebote = await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: stadtteile.map((stadtteil) {
          return ListTile(
            title: Text(stadtteil),
            onTap: () {
              Navigator.pop(context, stadtteil);
            },
          );
        }).toList(),
      )
      );
    },
  );
  setState(() {});
}


  void _textControllerListenerAngebote() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final textAdresse = _adresseController.text;
    final textZeit = _zeitController.text;
    final textStadt = selectedOptionStadtAngebote;
    final textStadtviertel = selectedOptionStadtteilAngebote;
    final textBezahlung = _bezahlungController.text;
    final textKontakt = _kontaktController.text;
    final textJob = selectedOption;
    await _notesService.updateNoteAngebote(
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

  void _setupTextControllerListenerAngebote() {
    _adresseController.removeListener(_textControllerListenerAngebote);
    _adresseController.addListener(_textControllerListenerAngebote);
    _zeitController.removeListener(_textControllerListenerAngebote);
    _zeitController.addListener(_textControllerListenerAngebote);
    _kontaktController.removeListener(_textControllerListenerAngebote);
    _kontaktController.addListener(_textControllerListenerAngebote);
    _bezahlungController.removeListener(_textControllerListenerAngebote);
    _bezahlungController.addListener(_textControllerListenerAngebote);
    _stadtController.removeListener(_textControllerListenerAngebote);
    _stadtController.addListener(_textControllerListenerAngebote);
    _stadtviertelController.removeListener(_textControllerListenerAngebote);
    _stadtviertelController.addListener(_textControllerListenerAngebote);
  }

  Future<CloudNote> createOrGetExistingNoteAngebote(
      BuildContext context) async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote =
        await _notesService.createNewNoteAngebote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_kontaktController.text.isEmpty && selectedOption == "Choose what you want to do"  && note != null) {
      _notesService.deleteNoteAngebote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmptyAngebote() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final textAdresse = _adresseController.text;
    final textZeit = _zeitController.text;
    final textStadt = selectedOptionStadtAngebote;
    final textStadtviertel = selectedOptionStadtteilAngebote;
    final textBezahlung = _bezahlungController.text;
    final textKontakt = _kontaktController.text;
    final textJob = selectedOption;
    if(_kontaktController.text.isEmpty && selectedOption != "Choose what you want to do"){
    await _notesService.updateNoteAngebote(
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
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmptyAngebote();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('I want to do...'),
        backgroundColor: Colors.green.shade200,
        actions: [
          IconButton(
            onPressed: () {
              _deleteNoteIfTextIsEmpty();
              _saveNoteIfTextNotEmptyAngebote();

              Navigator.of(context).pushNamedAndRemoveUntil(
                  notesViewAngeboteRoute, (route) => false);
              showAutomaticDeleteDialog(context);
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNoteAngebote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListenerAngebote();

              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showPopupMenuJob(context);
                    },
                    child: Text(selectedOption),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () {
                        showPopupMenuStadt(context);
                      },
                      child: Text(selectedOptionStadtAngebote)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () {
                        if(selectedOptionStadtAngebote == 'München'){
                        showPopupMenuStadtteil(context, 'Sendling', 'Bogenhausen','Haidhausen','Schwabing','Ried','Lehel','Pasing','','','');
                        }else if(selectedOptionStadtAngebote == 'Stutgart'){
                          showPopupMenuStadtteil(context, 'Mitte', 'Bad Cannstatt', 'Vaihingen', 'Feuerbach', 'Degerloch', 'Zuffenhausen', 'Sillenbruch', 'Möhringen', 'Ostheim', 'West');
                        }else if(selectedOptionStadtAngebote == 'Berlin'){
                          showPopupMenuStadtteil(context, 'Mitte', 'Kreuzberg', 'Penzlauer Berg', 'Charlottenburg', 'Friedrichshain', 'Neukölln', 'Schöneberg', 'Wedding', 'Tiergarten', 'Steglitz-Zehlendorf');
                        }else if(selectedOptionStadtAngebote == 'Hamburg'){
                          showPopupMenuStadtteil(context, 'Altstadt', 'Neustadt', 'St. Pauli', 'Sternschanze', 'Eimsbüttel', 'Altona', 'Ottensee', 'Haffencity', 'Winterhude', 'Blankensee');
                        }
                      },
                      child: Text(selectedOptionStadtteilAngebote)),
                  TextField(
                    controller: _adresseController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText:
                          'Give an exakt location about where the job will be. Can be more than one place.',
                    ),
                  ),
                  TextField(
                    controller: _zeitController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText:
                          'When do you have time to do the job?',
                    ),
                  ),
                  
                  TextField(
                    controller: _bezahlungController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText:
                          'How much do you want to get paid?',
                    ),
                  ),
                  TextField(
                    controller: _kontaktController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Give in something to Kontakt you',
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
