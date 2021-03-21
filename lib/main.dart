import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/add_or_edit_dream_screen.dart';
import 'views/dream_list_screen.dart';
import 'views/dream_details_screen.dart';

var allDreams = <Dream>[];
SharedPreferences prefs;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Diary',
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      themeMode: ThemeMode.system,
      initialRoute: "/",
      routes: {
        "/": (context) => DreamListScreen(),
        "/newOrEditDream": (context) => AddOrEditDreamScreen(),
        "/dreamDetails": (context) => DreamDetailsScreen(),
      },
    );
  }
}

class Dream {
  String title;
  String content;
  String id;
  DateTime date;

  Dream(this.title, this.content, this.id);

  Map<String, dynamic> toJson() => {
        'title': this.title,
        'content': this.content,
        'id': this.id,
      };
}

class DreamAndList {
  Dream dream;
  var list;

  DreamAndList(this.dream, this.list);
}
