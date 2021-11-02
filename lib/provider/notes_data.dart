import 'package:flutter/cupertino.dart';
import 'package:notes_app_provider/database/notes_database.dart';
import 'package:notes_app_provider/models/note.dart';

class NotesData extends ChangeNotifier {
  final NotesDatabase db = NotesDatabase.instance;

  List<Note> _searchedNotes = [];
  List<Note> _notes = [];
  bool _isLoading = false;
  bool _isSearching = false;

  List<Note> get searchedNotes => _searchedNotes;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;

  bool isNotesEmpty() => _notes.isEmpty;

  //Setters
  void setSearchedNotes(List<Note> notes) {
    _searchedNotes = notes;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  void setSearchedNotesToNotes() {
    _searchedNotes = _notes.toList();
    print(_notes);
    notifyListeners();
  }

  void searchForNotes(String noteName) {
    List<Note> result = _notes
        .where(
            (note) => note.title.toLowerCase().contains(noteName.toLowerCase()))
        .toList();

    _searchedNotes = result;
    notifyListeners();
  }

  //Db related
  void getNotesFromDB() async {
    _isLoading = true;
    // await Future.delayed(const Duration(seconds: 3), () {});
    _notes = await db.readAll();
    // print(notes.map((e) => e.id).toList());
    //Passing list value instead of reference, basically creating a new copy of the list.

    _searchedNotes = _notes.toList();
    _isSearching = false;
    _isLoading = false;

    notifyListeners();
  }

  Future deleteNote(int index) async {
    await db.delete(index);
  }
}
