import 'package:flutter/material.dart';
import 'package:notes_app_provider/components/note_screen_template.dart';

class SearchBox extends StatefulWidget {
  final onChangedTextCallback callback;

  SearchBox({required this.callback});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.text = '';
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
