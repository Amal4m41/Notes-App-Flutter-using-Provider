import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_provider/components/capsule_text_border.dart';
import 'package:notes_app_provider/components/note_screen_template.dart';
import 'package:notes_app_provider/components/round_icon_border.dart';
import 'package:notes_app_provider/models/note.dart';
import 'package:notes_app_provider/utils/constants.dart';
import 'package:notes_app_provider/utils/widget_functions.dart';
import 'package:notes_app_provider/database/notes_database.dart';

class CreateNoteScreen extends StatelessWidget {
  static const String id = "CreateNoteScreen";

  //If note id it passed then it's an update operation instead of create.
  final int? noteId;
  final String title;
  final String description;
  final int colorIndex;

  CreateNoteScreen(
      {this.title = '',
      this.description = '',
      this.noteId,
      this.colorIndex = 0}) {}

  @override
  Widget build(BuildContext context) {
    String titleText = '';
    String descriptionText = '';
    int selectedColor =
        colorIndex; //stores the index of the color from color list

    print("CREATE NOTE SCREEN");
    return NoteScreenTemplate(
      titleText: titleText,
      descriptionText: descriptionText,
      onChangedTitleText: (String value) {
        titleText = value;
      },
      onChangedDescriptionText: (String value) {
        descriptionText = value;
      },
      selectedColor: noteColors[selectedColor],
      callback: (Color value) {
        selectedColor = noteColors.indexOf(value);
        Navigator.pop(context);
      },
      toolbar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: RoundIconBorder(icon: Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          InkWell(
            child: CapsuleTextBorder(text: "Save"),
            onTap: () async {
              String title = titleText;
              String description = descriptionText;
              //If the left most condition is true, then the next condition won't be checked ...therefore it won't throw null exception.
              if (title.trim().isEmpty) {
                showErrorSnackBar(context, "Title can't be empty");
              } else {
                //If the string just container white spaces then replace it with an empty string to save storage.
                description = description.trim().isEmpty ? '' : description;

                if (noteId == null) {
                  Note note = await NotesDatabase.instance.insertNote(
                    Note(
                      title: title,
                      description: description,
                      colorIndex: selectedColor,
                      createdTime: DateTime.now(),
                    ),
                  );

                  Navigator.pop(context, DbNoteAction.insert);
                } else {
                  int result = await NotesDatabase.instance.update(
                    Note(
                      id: noteId!,
                      title: title,
                      description: description,
                      colorIndex: selectedColor,
                      createdTime: DateTime.now(),
                    ),
                  );
                  Navigator.pop(context, DbNoteAction.update);
                }
                // print(title);
                // print(description);
              }
            },
          ),
        ],
      ),
    );
  }
}

class CreateNoteScreenArguments {
  final int? noteId;
  final String title;
  final String description;
  final int colorIndex;

  CreateNoteScreenArguments(
      {this.title = '',
      this.description = '',
      this.noteId,
      this.colorIndex = 0});
}
