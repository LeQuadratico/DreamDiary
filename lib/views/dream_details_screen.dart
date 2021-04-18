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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_lifecycle_reactor.dart';
import '../main.dart';
import '../globals.dart' as globals;

class DreamDetailsScreen extends StatefulWidget {
  @override
  _DreamDetailsScreenState createState() => _DreamDetailsScreenState();
}

class _DreamDetailsScreenState extends State<DreamDetailsScreen> {
  Dream dream;
  var list;

  @override
  Widget build(BuildContext context) {
    final DreamAndList args = ModalRoute.of(context).settings.arguments;
    dream = args.dream;
    list = args.list;
    IconData icon = Icons.error;
    switch (dream.mood) {
      case 0:
        icon = Icons.sentiment_very_dissatisfied;
        break;
        case 1:
        icon = Icons.sentiment_dissatisfied;
        break;
        case 2:
        icon = Icons.sentiment_neutral;
        break;
        case 3:
        icon = Icons.sentiment_satisfied_alt;
        break;
        case 4:
        icon = Icons.sentiment_very_satisfied;
        break;
    }

    return AppLifecycleReactor(Scaffold(
      appBar: AppBar(
        title: Text(dream.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 85),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                icon,
                size: 50,
              ),
              Text(
                DateFormat.yMMMMd(Localizations.localeOf(context).languageCode)
                    .format(dream.date),
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: 10),
              Text(dream.content),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _editDream,
        tooltip: AppLocalizations.of(context).editDream,
        child: Icon(Icons.edit),
      ),
    ));
  }

  void _editDream() async {
    final result =
        await Navigator.pushNamed(context, "/newOrEditDream", arguments: dream);

    if (result == null) return;

    setState(() {
      globals.secureStorageManager.replaceDream(dream, result);
      /* final index = allDreams.indexOf(dream);
      allDreams.remove(dream);
      allDreams.insert(index, result); */
      dream = result;

      globals.getSortMode().then((sortMode) {
        setState(() {
          if (sortMode == "newFirst")
            allDreams.sort((b, a) => a.date.compareTo(b.date));
          else if (sortMode == "oldFirst")
            allDreams.sort((a, b) => a.date.compareTo(b.date));
        });
      });
    });

    list();
  }
}
