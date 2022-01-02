import 'package:flutter/material.dart';
import 'package:flutter_keep/models/note_model.dart';
import 'package:flutter_keep/pages/archive_page.dart';
import 'package:flutter_keep/pages/home.dart';
import 'package:flutter_keep/services/db.dart';
import 'package:flutter_keep/widgets/edit_notes.dart';
import 'package:flutter_keep/theme/colors.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class NotesPage extends StatefulWidget {
  Note note;
  // ignore: use_key_in_widget_constructors
  NotesPage({required this.note});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
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
              await NotesDb.instance.pinNote(widget.note);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            },
            icon: Icon(
                widget.note.pin ? Icons.push_pin : Icons.push_pin_outlined),
          ),
          IconButton(
            splashRadius: 17,
            onPressed: () async {
              await NotesDb.instance.archiveNote(widget.note);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArchivePage(),
                ),
              );
            },
            icon: Icon(
              widget.note.isArchive
                  ? Icons.cloud_download
                  : Icons.cloud_download_outlined,
            ),
          ),
          IconButton(
            splashRadius: 17,
            onPressed: () async {
              await NotesDb.instance.delteNote(widget.note);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            },
            icon: const Icon(Icons.delete_forever_outlined),
          ),
          IconButton(
            splashRadius: 17,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNotes(note: widget.note),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Created On ${DateFormat('dd-MM-yyyy - kk:mm').format(widget.note.createdTime)}",
              style: TextStyle(
                color: white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.note.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.note.content,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
