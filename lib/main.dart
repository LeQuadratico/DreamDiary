/* Dream Diary
Copyright (C) 2021 LeQuadratico

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>. */

import 'package:dream_diary/views/local_auth_screen.dart';
import 'package:dream_diary/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'views/add_or_edit_dream_screen.dart';
import 'views/dream_list_screen.dart';
import 'views/dream_details_screen.dart';
import 'globals.dart' as globals;

List<Dream> allDreams = <Dream>[];

void main() {
  runApp(MyApp());
  globals.initGlobals();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /* debugShowCheckedModeBanner: false, */
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
  int mood;

  Dream(this.title, this.content, this.id, this.date, this.mood);

  Map<String, dynamic> toJson() => {
        'title': this.title,
        'content': this.content,
        'id': this.id,
        'date': this.date.toIso8601String(),
        'mood': this.mood,
      };
}

class DreamAndList {
  Dream dream;
  var list;

  DreamAndList(this.dream, this.list);
}
