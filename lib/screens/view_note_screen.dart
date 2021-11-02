import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_provider/components/round_icon_border.dart';
import 'package:notes_app_provider/models/note.dart';
import 'package:notes_app_provider/provider/notes_data.dart';
import 'package:notes_app_provider/utils/constants.dart';
import 'package:notes_app_provider/utils/widget_functions.dart';
import 'package:notes_app_provider/database/notes_database.dart';
import 'package:provider/src/provider.dart';
import 'create_note_screen.dart';

class ViewNoteScreen extends StatelessWidget {
  static const String id = "EditNoteScreen";

  final Note note;
  ViewNoteScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: RoundIconBorder(icon: Icons.arrow_back),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  InkWell(
                    child: RoundIconBorder(
                      icon: Icons.edit,
                      iconColor: Colors.blue.shade100,
                    ),
                    onTap: () async {
                      String title = note.title;
                      String description = note.description;

                      // print("COLOR VALUE : ${note.colorIndex}");
                      final DbNoteAction? result = await Navigator.pushNamed(
                        context,
                        CreateNoteScreen.id,
                        arguments: CreateNoteScreenArguments(
                            title: title,
                            description: description,
                            colorIndex: note.colorIndex,
                            noteId: note.id),
                      ) as DbNoteAction?;

                      Navigator.pop(context, result); //return to homescreen
                    },
                  ),
                  getHorizontalSpace(5),
                  InkWell(
                    child: RoundIconBorder(
                      icon: Icons.delete,
                      iconColor: Colors.red.shade100,
                    ),
                    onTap: () async {
                      await context.read<NotesData>().deleteNote(note.id!);
                      Navigator.pop(context, DbNoteAction.delete);
                    },
                  ),
                ],
              ),
              getVerticalSpace(10),
              Container(
                height: MediaQuery.of(context).size.height - 120,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      getVerticalSpace(20),
                      Text(DateFormat.yMMMd().format(note.createdTime),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade500)),
                      getVerticalSpace(20),
                      Text(
                        note.description,
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
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

class ViewNoteScreenArguments {
  final Note note;

  ViewNoteScreenArguments({required this.note});
}
