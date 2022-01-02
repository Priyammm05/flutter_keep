// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_keep/models/note_model.dart';
import 'package:flutter_keep/services/auth.dart';
import 'package:flutter_keep/services/db.dart';
// ignore: unused_import
import 'package:flutter_keep/services/firestore_db.dart';
import 'package:flutter_keep/services/login_info.dart';
import 'package:flutter_keep/widgets/create_notes.dart';
import 'package:flutter_keep/pages/notes_page.dart';
import 'package:flutter_keep/pages/search_page.dart';
import 'package:flutter_keep/widgets/login.dart';
import 'package:flutter_keep/widgets/side_menu_bar.dart';
import 'package:flutter_keep/theme/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool isLoading = true;
  bool isStaggered = true;
  late String imageUrl;
  List<Note>? notesList;

  @override
  void initState() {
    super.initState();
    LocalDataSaver.saveSync(false);
    getNotes();
  }

  Future createEntry(Note note) async {
    await NotesDb.instance.create(note);
  }

  Future getNotes() async {
    LocalDataSaver.getImg().then((value) {
      if (mounted) {
        setState(() {
          imageUrl = value.toString();
        });
      }
    });

    notesList = await NotesDb.instance.readNotes();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future getOneNote(int id) async {
    await NotesDb.instance.readOneNote(id);
  }

  Future updateNote(Note note) async {
    await NotesDb.instance.updateNote(note);
  }

  Future deleteNote(Note note) async {
    await NotesDb.instance.delteNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            endDrawerEnableOpenDragGesture: true,
            key: _drawerKey,
            drawer: const SideMenuBar(),
            backgroundColor: bgColor,
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add, size: 35),
              backgroundColor: cardColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateNotes()));
              },
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.4, horizontal: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateColor.resolveWith(
                                    (states) => white.withOpacity(0.1)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                _drawerKey.currentState!.openDrawer();
                              },
                              child: const Icon(Icons.menu, color: white),
                            ),
                            const SizedBox(width: 3.8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SearchPage(),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 55,
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Search Your Notes',
                                      style: TextStyle(
                                        color: white.withOpacity(0.5),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  TextButton(
                                    style: ButtonStyle(
                                      overlayColor:
                                          MaterialStateColor.resolveWith(
                                        (states) => white.withOpacity(0.1),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isStaggered = !isStaggered;
                                      });
                                    },
                                    child: const Icon(Icons.grid_view,
                                        color: white),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      signOut();
                                      LocalDataSaver.saveLoginData(false);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Login(),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      onBackgroundImageError:
                                          (Object, StackTrace) {
                                        // ignore: avoid_print
                                        print('OK');
                                      },
                                      radius: 16,
                                      backgroundImage:
                                          NetworkImage(imageUrl.toString()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      isStaggered ? noteGridSection() : noteListSection(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget noteGridSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Column(
            children: [
              Text(
                'ALL',
                style: TextStyle(
                  color: white.withOpacity(0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: StaggeredGridView.countBuilder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notesList!.length,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            crossAxisCount: 4,
            staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotesPage(note: notesList![index])),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    border:
                        Border.all(color: Colors.amberAccent.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notesList![index].title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        notesList![index].content.length > 250
                            ? '${notesList![index].content.substring(0, 250)}...'
                            : notesList![index].content,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget noteListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Column(
            children: [
              Text(
                'ALL',
                style: TextStyle(
                  color: white.withOpacity(0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notesList!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotesPage(note: notesList![index])),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: white.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notesList![index].title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        notesList![index].content.length > 400
                            ? '${notesList![index].content.substring(0, 400)}...'
                            : notesList![index].content,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
