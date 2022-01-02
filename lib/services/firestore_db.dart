import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_keep/models/note_model.dart';
import 'package:flutter_keep/services/db.dart';
import 'package:flutter_keep/services/login_info.dart';

class FireDB {
  //CREATE,READ,UPDATE,DELETE
  final FirebaseAuth _auth = FirebaseAuth.instance;

  createNewNoteFirestore(Note note) async {
    LocalDataSaver.getSync().then((isSyncOn) async {
      if (isSyncOn.toString() == 'true') {
        final User? currentUser = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(currentUser!.email)
            .collection("usernotes")
            .doc(note.uniqueID)
            .set({
          "uniqueID": note.uniqueID,
          "Title": note.title,
          "content": note.content,
          "date": note.createdTime,
        }).then((_) {
          // ignore: avoid_print
          print("DATA ADDED SUCCESSFULLY");
        });
      }
    });
  }

  getAllStoredNotes() async {
    LocalDataSaver.getSync().then((isSyncOn) async {
      if (isSyncOn.toString() == 'true') {
        final User? currentUser = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(currentUser!.email)
            .collection("usernotes")
            .orderBy("date")
            .get()
            .then((querySnapshot) {
          // ignore: avoid_function_literals_in_foreach_calls
          querySnapshot.docs.forEach((result) {
            Map note = result.data();

            NotesDb.instance.create(
              Note(
                uniqueID: note["uniqueID"],
                title: note["Title"],
                content: note["content"],
                createdTime: note["date"],
                pin: false,
                isArchive: false,
              ),
            ); //Add Notes In Database
          });
        });
      }
    });
  }

  updateNoteFirestore(Note note) async {
    LocalDataSaver.getSync().then(
      (isSyncOn) async {
        if (isSyncOn.toString() == 'true') {
          final User? currentUser = _auth.currentUser;
          await FirebaseFirestore.instance
              .collection("notes")
              .doc(currentUser!.email)
              .collection("usernotes")
              .doc(note.uniqueID.toString())
              .update({
            "Title": note.title.toString(),
            "content": note.content
          }).then((_) {
            // ignore: avoid_print
            print("DATA ADDED SUCCESFULLY");
          });
        }
      },
    );
  }

  deleteNoteFirestore(Note note) async {
    LocalDataSaver.getSync().then((isSyncOn) async {
      if (isSyncOn.toString() == 'true') {
        final User? currentUser = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(currentUser!.email.toString())
            .collection("usernotes")
            .doc(note.uniqueID.toString())
            .delete()
            .then((_) {
          // ignore: avoid_print
          print("DATA DELETED SUCCESSFULLY");
        });
      }
    });
  }
}
