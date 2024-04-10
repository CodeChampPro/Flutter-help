import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String textJob;
  final String textAdresse;
  final String textStadt;
  final String textStadtviertel;
  final String textZeit;
  final String textBezahlung;
  final String textKontakt;
  final String textAngebot;
  final Timestamp deletionTime;
  final String userId;

  
   const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.textJob,
    required this.textAdresse,
    required this.textZeit,
    required this.textBezahlung,
    required this.textKontakt,
    required this.textStadt,
    required this.textStadtviertel,
    required this.textAngebot,
    required this.deletionTime,
    required this.userId,
   
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot, )
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        textJob = snapshot.data()[textJobFieldName] as String,
        textAdresse = snapshot.data()[textAdresseFieldName] as String,
        textZeit = snapshot.data()[textZeitFieldName] as String,
        textBezahlung = snapshot.data()[textBezahlungFieldName] as String,
        textStadt = snapshot.data()[textStadtFieldName] as String,
        textStadtviertel = snapshot.data()[textStadtviertelFieldName] as String,
        textAngebot = snapshot.data()[textAngebotFieldName] as String,
        deletionTime = snapshot.data()[deletionTimeFieldName] as Timestamp,
        userId = snapshot.data()[userIdFieldName] as String,
        textKontakt = snapshot.data()[textKontaktFieldName] as String;
                
}