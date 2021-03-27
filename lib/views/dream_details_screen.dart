import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_lifecycle_reactor.dart';
import '../main.dart';

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
    return AppLifecycleReactor( Scaffold(
      appBar: AppBar(
        title: Text(dream.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat.yMMMMd(Localizations.localeOf(context).languageCode).format(dream.date),
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
      final index = allDreams.indexOf(dream);
      allDreams.remove(dream);
      allDreams.insert(index, result);
      dream = result;
    });

    list();
    prefs.setString("allDreams", jsonEncode(allDreams));
  }
}
