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

import 'package:intl/intl.dart';

import '../app_lifecycle_reactor.dart';
import 'nav_drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';
import '../globals.dart' as globals;

class DreamListScreen extends StatefulWidget {
  @override
  _DreamListScreenState createState() => _DreamListScreenState();
}

class _DreamListScreenState extends State<DreamListScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final bool? args = ModalRoute.of(context)!.settings.arguments as bool?;
      if (args != null && args) _pushAddDream();
    });
  }

  reload() {
    setState(() {});
  }

  loadData() async {
    List<Dream>? _loadedDreams = <Dream>[];
    _loadedDreams = globals.secureStorageManager.getAllDreams();

    setState(() {
      allDreams = _loadedDreams!;
      globals.getSortMode().then((sortMode) {
        setState(() {
          if (sortMode == "newFirst")
            allDreams.sort((b, a) => a.date.compareTo(b.date));
          else if (sortMode == "oldFirst")
            allDreams.sort((a, b) => a.date.compareTo(b.date));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLifecycleReactor(Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
      ),
      body: _buildDreamList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddDream,
        tooltip: AppLocalizations.of(context)!.addDream,
        child: Icon(Icons.add),
      ),
      drawer: NavDrawer(),
    ));
  }

  Widget _buildDreamList() {
    return ListView.separated(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: allDreams.length,
        itemBuilder: (context, index) {
          return _buildRow(allDreams[index]);
        });
  }

  Widget _buildRow(Dream dream) {
    return Dismissible(
      child: ListTile(
        title: Text(dream.title),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMMd(
                      Localizations.localeOf(context).languageCode)
                  .format(dream.date)),
              SizedBox(height: 8),
              Text(dream.content),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, "/dreamDetails",
              arguments: DreamAndList(dream, reload));
        },
      ),
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Row(
            children: [Icon(Icons.delete)],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.confirm),
              content: Text(AppLocalizations.of(context)!.confirmDeleteDream),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child:
                      Text(AppLocalizations.of(context)!.cancel.toUpperCase()),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child:
                      Text(AppLocalizations.of(context)!.delete.toUpperCase()),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (dir) {
        setState(() {
          globals.secureStorageManager.removeDream(dream);
          /* allDreams.remove(dream); */
        });
      },
      key: ValueKey(dream.id),
    );
  }

  void _pushAddDream() async {
    final result = await Navigator.pushNamed(context, "/newOrEditDream");

    if (result == null) return;

    setState(() {
      globals.secureStorageManager.addDream(result as Dream);
      globals.getSortMode().then((sortMode) {
        setState(() {
          if (sortMode == "newFirst")
            allDreams.sort((b, a) => a.date.compareTo(b.date));
          else if (sortMode == "oldFirst")
            allDreams.sort((a, b) => a.date.compareTo(b.date));
        });
      });
    });
  }
}
