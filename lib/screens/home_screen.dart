import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_provider/components/custom_progress_indicator.dart';
import 'package:notes_app_provider/components/notes_empty_message.dart';
import 'package:notes_app_provider/components/notes_staggered_grid_view.dart';
import 'package:notes_app_provider/components/round_icon_border.dart';
import 'package:notes_app_provider/components/search_box.dart';
import 'package:notes_app_provider/database/notes_database.dart';
import 'package:notes_app_provider/models/note.dart';
import 'package:notes_app_provider/provider/notes_data.dart';
import 'package:notes_app_provider/utils/constants.dart';
import 'package:notes_app_provider/utils/widget_functions.dart';
import 'package:provider/src/provider.dart';

import 'create_note_screen.dart';
import 'view_note_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String id = "HomeScreen";

  HomeScreen(BuildContext context) {
    context.read<NotesData>().getNotesFromDB();
  }

  @override
  Widget build(BuildContext context) {
    // print("HOME SCREEN");
    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.all(10).copyWith(bottom: 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Notes",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                    ),
                    InkWell(
                      onTap: () {
                        bool isSearching =
                            !context.read<NotesData>().isSearching;
                        context.read<NotesData>().setIsSearching(isSearching);
                        print(isSearching);
                        //When the search option is switched off, display the entire notes list.
                        !isSearching
                            ? context
                                .read<NotesData>()
                                .setSearchedNotesToNotes()
                            : null;
                      },
                      child: RoundIconBorder(
                          icon: context.watch<NotesData>().isSearching
                              ? Icons.search_off
                              : Icons.search),
                    ),
                  ],
                ),
              ),
              getVerticalSpace(10),
              context.watch<NotesData>().isSearching
                  ? SearchBox(
                      callback: (String searchText) {
                        print(searchText);
                        // print(notes);
                        context.read<NotesData>().searchForNotes(searchText);
                      },
                    )
                  : const SizedBox(height: 0, width: 0),
              Expanded(
                child: context.watch<NotesData>().isNotesEmpty()
                    ? NotesEmptyMessage()
                    : Stack(
                        children: [
                          NotesStaggeredGridView(
                            notesList: context.watch<NotesData>().searchedNotes,
                            onTapNoteItem: (int itemIndex) async {
                              Note selectedNote = context
                                  .read<NotesData>()
                                  .searchedNotes[itemIndex];

                              DbNoteAction? result = await Navigator.pushNamed(
                                      context, ViewNoteScreen.id,
                                      arguments: ViewNoteScreenArguments(
                                          note: context
                                              .read<NotesData>()
                                              .searchedNotes[itemIndex]))
                                  as DbNoteAction?;

                              if (result == DbNoteAction.delete) {
                                context.read<NotesData>().getNotesFromDB();
                                showSnackBarWithAction(
                                  context: context,
                                  message: "You deleted a note!",
                                  onPressed: () async {
                                    // print("Deleted  : ${selectedNote.id}");
                                    await NotesDatabase.instance
                                        .insertNote(selectedNote);
                                    context.read<NotesData>().getNotesFromDB();
                                  },
                                );
                              } else if (result == DbNoteAction.update) {
                                context.read<NotesData>().getNotesFromDB();
                              }
                            },
                          ),
                          context.read<NotesData>().isLoading
                              ? CustomProgressIndicator(
                                  textMsg: "Loading Notes ...",
                                )
                              : const SizedBox(
                                  height: 0, width: 0), //Dummy widget.
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey.shade700,
        onPressed: () async {
          //If we user just presses the back button, the screen will popped returning a null
          DbNoteAction? result = await Navigator.pushNamed(
              context, CreateNoteScreen.id,
              arguments: CreateNoteScreenArguments()) as DbNoteAction?;
          if (result == DbNoteAction.insert) {
            context.read<NotesData>().getNotesFromDB();
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}
