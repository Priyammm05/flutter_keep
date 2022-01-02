import 'package:flutter/material.dart';
import 'package:flutter_keep/models/note_model.dart';
import 'package:flutter_keep/pages/home.dart';
import 'package:flutter_keep/services/db.dart';
import 'package:flutter_keep/theme/colors.dart';
import 'package:uuid/uuid.dart';

class CreateNotes extends StatefulWidget {
  const CreateNotes({Key? key}) : super(key: key);

  @override
  _CreateNotesState createState() => _CreateNotesState();
}

class _CreateNotesState extends State<CreateNotes> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  // Create uuid
  var uuid = const Uuid();

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    content.dispose();
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
              await NotesDb.instance.create(Note(
                uniqueID: uuid.v1(),
                content: content.text,
                createdTime: DateTime.now(),
                title: title.text,
                pin: false,
                isArchive: false,
              ));
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
              TextField(
                controller: title,
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
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.2,
                child: TextField(
                  controller: content,
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
            ],
          ),
        ),
      ),
    );
  }
}
