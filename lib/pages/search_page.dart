import 'package:flutter/material.dart';
import 'package:flutter_keep/models/note_model.dart';
import 'package:flutter_keep/pages/notes_page.dart';
import 'package:flutter_keep/services/db.dart';
import 'package:flutter_keep/theme/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<int> searchResultIDs = [];
  List<Note?> searchResultNotes = [];

  bool isLoading = false;

  void searchResults(String query) async {
    searchResultNotes.clear();
    setState(() {
      isLoading = true;
    });
    final resultIds = await NotesDb.instance.getNoteString(query);
    List<Note?> searchResultNotesLocal = [];

    for (var element in resultIds) {
      final searchNote = await NotesDb.instance.readOneNote(element);
      searchResultNotesLocal.add(searchNote);
      setState(() {
        searchResultNotes.add(searchNote);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: white.withOpacity(0.1)),
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                          (states) => white.withOpacity(0.1),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                          const Icon(Icons.arrow_back_outlined, color: white),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        cursorColor: white,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Search Your Notes",
                          hintStyle: TextStyle(
                              color: white.withOpacity(0.5), fontSize: 16),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            searchResults(value.toLowerCase());
                          });
                        },
                      ),
                    ),
                  ],
                ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : noteGridSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noteGridSection() {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "SEARCH RESULTS",
                  style: TextStyle(
                    color: white.withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
            child: StaggeredGridView.countBuilder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: searchResultNotes.length,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              crossAxisCount: 4,
              staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesPage(
                        note: searchResultNotes[index] as Note,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(
                          color: Colors.amberAccent.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(searchResultNotes[index]!.title,
                          style: const TextStyle(
                              color: white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        searchResultNotes[index]!.content.length > 250
                            ? "${searchResultNotes[index]!.content.substring(0, 250)}..."
                            : searchResultNotes[index]!.content,
                        style: const TextStyle(color: white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
