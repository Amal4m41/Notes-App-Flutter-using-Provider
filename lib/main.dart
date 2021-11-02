import 'package:flutter/material.dart';
import 'package:notes_app_provider/provider/notes_data.dart';
import 'package:notes_app_provider/screens/create_note_screen.dart';
import 'package:notes_app_provider/screens/home_screen.dart';
import 'package:notes_app_provider/screens/view_note_screen.dart';
import 'package:provider/provider.dart';
import 'package:notes_app_provider/provider/notes_data.dart';
import 'models/note.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => NotesData(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(context),
      },
      //For named routes with parameters.
      onGenerateRoute: (settings) {
        // If you push the PassArguments route
        if (settings.name == ViewNoteScreen.id) {
          // Cast the arguments to the correct
          // type: ScreenArguments.
          final args = settings.arguments as ViewNoteScreenArguments;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return ViewNoteScreen(note: args.note);
            },
          );
        }
        if (settings.name == CreateNoteScreen.id) {
          final args = settings.arguments as CreateNoteScreenArguments;

          return MaterialPageRoute(
            builder: (context) {
              return CreateNoteScreen(
                  title: args.title,
                  description: args.description,
                  colorIndex: args.colorIndex,
                  noteId: args.noteId);
            },
          );
        }
        // The code only supports
        // PassArgumentsScreen.routeName right now.
        // Other values need to be implemented if we
        // add them. The assertion here will help remind
        // us of that higher up in the call stack, since
        // this assertion would otherwise fire somewhere
        // in the framework.
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
