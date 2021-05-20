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

import 'package:dream_diary/app_lifecycle_reactor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';

class AddOrEditDreamScreen extends StatefulWidget {
  @override
  _AddOrEditDreamScreenState createState() => _AddOrEditDreamScreenState();
}

class _AddOrEditDreamScreenState extends State<AddOrEditDreamScreen> {
  final _formKey = GlobalKey<FormState>();
  late Dream newDream;
  List<bool> selectedMood = List<bool>.filled(5, false);
  late DateTime selectedDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (ModalRoute.of(context)!.settings.arguments != null)
      newDream = ModalRoute.of(context)!.settings.arguments as Dream;
    else
      newDream = new Dream("", "", Uuid().v4(), DateTime.now(), 2);

    for (var i = 0; i < 5; i++) {
      if (i == newDream.mood)
        selectedMood[i] = true;
      else
        selectedMood[i] = false;
    }

    selectedDate = newDream.date;
  }

  @override
  Widget build(BuildContext context) {
    return AppLifecycleReactor(Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addEditDream),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  initialValue: newDream.title,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.title,
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val) => newDream.title = val!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterTitle;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: newDream.content,
                  keyboardType: TextInputType.multiline,
                  /*  minLines: 5, */
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.content,
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val) => newDream.content = val!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterText;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ToggleButtons(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.sentiment_very_dissatisfied,
                        size: 40,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.sentiment_dissatisfied,
                        size: 40,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.sentiment_neutral,
                        size: 40,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.sentiment_satisfied_alt,
                        size: 40,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.sentiment_very_satisfied,
                        size: 40,
                      ),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (var i = 0; i < 5; i++) {
                        if (i == index)
                          selectedMood[i] = true;
                        else
                          selectedMood[i] = false;
                      }
                    });
                  },
                  isSelected: selectedMood,
                ),
                SizedBox(height: 20),
                OutlinedButton(
                  child: Text(DateFormat.yMMMMd(
                          Localizations.localeOf(context).languageCode)
                      .format(selectedDate)),
                  onPressed: () async {
                    var newTime = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000, 0, 0),
                        lastDate:
                            DateTime.now().add(new Duration(days: 360 * 100)));

                    if (newTime != null) {
                      setState(() {
                        selectedDate = newTime;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveDream,
        tooltip: AppLocalizations.of(context)!.saveDream,
        child: Icon(Icons.save),
      ),
    ));
  }

  void saveDream() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      for (var i = 0; i < 5; i++) {
        if (selectedMood[i]) newDream.mood = i;
      }

      newDream.date = selectedDate;

      Navigator.pop(context, newDream);
    }
  }
}
