import 'package:flutter/material.dart';
import 'package:notes_app_provider/components/note_screen_template.dart';

class SearchBox extends StatefulWidget {
  final onChangedTextCallback callback;
  SearchBox({required this.callback});

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("INITSTATE");
    //so that all notes appear when user clicks the search button, since '' is contained by all strings.
    searchController.text = '';
  }

  @override
  void dispose() {
    print("DISPOSE");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("SEARCH BOX SCREEN");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        autofocus: true,
        controller: searchController,
        onChanged: (_) {
          // print(searchController.text);
          widget.callback(searchController.text);
          //No need to call setState() here, cuz the parent widget call setState after the above callback. Since the parent widget
          //is rebuilt, SearchBox being it's child widget is rebuilt too.
          // setState(() {});
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          suffixIcon: searchController.text.isEmpty
              ? null
              : InkWell(
                  onTap: () {
                    searchController.clear();
                    widget.callback(
                        ''); //so that all list notes will be displayed.
                  },
                  child: const Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          hintText: "Search for notes by title",
        ),
      ),
    );
  }
}
