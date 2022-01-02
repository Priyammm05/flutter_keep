import 'package:flutter/material.dart';
import 'package:flutter_keep/models/note_model.dart';
import 'package:flutter_keep/pages/home.dart';
import 'package:flutter_keep/services/db.dart';
import 'package:flutter_keep/theme/colors.dart';

// ignore: must_be_immutable
class EditNotes extends StatefulWidget {
  Note note;
  // ignore: use_key_in_widget_constructors
  EditNotes({required this.note});

  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  String? title;
  String? content;

  @override
  void initState() {
    super.initState();
    title = widget.note.title.toString();
    content = widget.note.content.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        actions: [
          IconButton(
            splashRadius: 17,
            onPressed: () async {
              Note newNote = Note(
                id: widget.note.id,
                uniqueID: widget.note.uniqueID,
                pin: widget.note.pin,
                isArchive: widget.note.isArchive,
                title: title as String,
                content: content as String,
                createdTime: widget.note.createdTime,
              );
              await NotesDb.instance.updateNote(newNote);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            },
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Form(
                child: TextFormField(
                  initialValue: title,
                  onChanged: (value) {
                    title = value;
                  },
                  cursorColor: white,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.2,
                child: Form(
                  child: TextFormField(
                    initialValue: content,
                    onChanged: (value) {
                      content = value;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: null,
                    cursorColor: white,
                    style: const TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Note',
                      hintStyle: TextStyle(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
