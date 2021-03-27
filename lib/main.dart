import 'package:dream_diary/views/local_auth_screen.dart';
import 'package:dream_diary/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      initialRoute: "/localAuth",
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en", ""),
        const Locale("de", ""),
      ],
      routes: {
        "/localAuth": (context) => LocalAuthScreen(),
        "/dreamList": (context) => DreamListScreen(),
        "/newOrEditDream": (context) => AddOrEditDreamScreen(),
        "/dreamDetails": (context) => DreamDetailsScreen(),
        "/settings": (context) => SettingsScreen(),
      },
    );
  }
}

class Dream {
  String title;
  String content;
  String id;
  DateTime date;

  Dream(this.title, this.content, this.id, this.date);

  Map<String, dynamic> toJson() => {
        'title': this.title,
        'content': this.content,
        'id': this.id,
        'date': this.date.toIso8601String(),
      };
}

class DreamAndList {
  Dream dream;
  var list;

  DreamAndList(this.dream, this.list);
}
