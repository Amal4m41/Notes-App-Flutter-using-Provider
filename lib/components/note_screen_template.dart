import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'note_color_picker.dart';
import 'package:notes_app_provider/utils/widget_functions.dart';

typedef onChangedTextCallback = void Function(String value);

class NoteScreenTemplate extends StatelessWidget {
  final Row toolbar;
  final String titleText;
  final String descriptionText;
  final onChangedTextCallback onChangedTitleText;
  final onChangedTextCallback onChangedDescriptionText;
  final bool editable;
  final Color selectedColor;
  final onChangedColorCallback callback;

  NoteScreenTemplate({
    required this.titleText,
    required this.descriptionText,
    required this.onChangedTitleText,
    required this.onChangedDescriptionText,
    required this.toolbar,
    this.editable = true,
    required this.selectedColor,
    required this.callback,
  });

  //IMPORTANT: the below build method will be called every time the s/w keyboard comes and goes on the screen.
  //Therefore the stateful widget 'SelectedColorWidget' which is a child widget of this stateless widget is created
  // in such a way to tackle this behaviour.
  @override
  Widget build(BuildContext context) {
    print("NOTESCREEN TEMPLATE");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              toolbar,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: editable,
                      onChanged: onChangedTitleText,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        // hintText: "Title",
                        labelText: "Title",
                        // floatingLabelStyle: TextStyle(color: Colors.blueGrey),
                        labelStyle: TextStyle(
                            textBaseline: TextBaseline.ideographic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey)),
                        // enabledBorder:
                        //     UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  editable
                      ? SelectedColorWidget(
                          selectedColor: selectedColor, callback: callback)
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        ),
                ],
              ),
              getVerticalSpace(5),
              Container(
                // color: Colors.greenAccent,
                //Get the height of the screen - height that'll be occupied by the keyboard when it's active - 160.
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewInsets.bottom -
                    170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey, width: 0.09),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: TextField(
                    enabled: editable,
                    onChanged: onChangedDescriptionText,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType
                        .multiline, //maxlines = true is needed for this to work
                    maxLines: null, //no limit on the number of lines.
                    decoration: const InputDecoration(
                      hintText: "Type note here.. ✍",
                      hintStyle: TextStyle(fontSize: 16),
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      // focusedBorder:
                      //     UnderlineInputBorder(borderSide: BorderSide.none),
                      // enabledBorder:
                      //     UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
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

class SelectedColorWidget extends StatefulWidget {
  final Color selectedColor;
  final onChangedColorCallback callback;
  SelectedColorWidget({required this.selectedColor, required this.callback}) {
    print('SELECTED COLOR WIDGET CONSTRUCTOR ');
  }

  @override
  _SelectedColorWidgetState createState() {
    print("SELECTED COLOR WIDGET CREATE STATE");
    return _SelectedColorWidgetState();
  }
}

class _SelectedColorWidgetState extends State<SelectedColorWidget> {
  late Color selectedColorPresent;

  @override
  void initState() {
    super.initState();
    selectedColorPresent = widget.selectedColor;
    print("SELECTED COLOR WIDGET INIT");
  }

  @override
  void didUpdateWidget(covariant SelectedColorWidget oldWidget) {
    print("SELECTED COLOR WIDGET didUpdateWidget");
    super.didUpdateWidget(oldWidget);
    //No need to call setState() as the build method is called after this method is finished.
    // selectedColorPresent = widget.selectedColor;
  }

  void pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: 230, horizontal: 50),
        title: const Text("Pick Note Color"),
        content: NoteColorPicker(
            selectedColor: selectedColorPresent,
            callback: (Color value) {
              setState(() {
                selectedColorPresent = value;
              });
              widget.callback(value);
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("SELECTED COLOR WIDGET BUILD");
    return InkWell(
      onTap: () {
        pickColor(context);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: selectedColorPresent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
