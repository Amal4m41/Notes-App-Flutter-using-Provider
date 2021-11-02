import 'package:flutter/material.dart';
import 'package:notes_app_provider/utils/widget_functions.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final Color color;
  final String createdDate;

  const NoteCard(
      {required this.title, required this.color, required this.createdDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          getVerticalSpace(10),
          Text(createdDate,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
