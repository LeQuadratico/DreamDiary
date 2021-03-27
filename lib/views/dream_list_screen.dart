import 'dart:convert';

import 'package:intl/intl.dart';

import '../app_lifecycle_reactor.dart';
import 'nav_drawer.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';

class DreamListScreen extends StatefulWidget {
  @override
  _DreamListScreenState createState() => _DreamListScreenState();
}

class _DreamListScreenState extends State<DreamListScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final bool args = ModalRoute.of(context).settings.arguments;
      if (args != null && args) _pushAddDream();
    });
  }

  void reload() {
    setState(() {});
  }

  loadData() async {
    prefs = await SharedPreferences.getInstance();
    final dreamsEncoded = prefs.getString("allDreams");

    var _loadedDreams = <Dream>[];

    if (dreamsEncoded != null) {
      var _dynamicList = jsonDecode(dreamsEncoded);
      _dynamicList.forEach((dynamic item) => {
            if (item != null)
              _loadedDreams
                  .add(Dream(item["title"], item["content"], item["id"], DateTime.parse(item["date"])))
          });
    }
    
    /*  else {
      var faker = Faker();
      var random = Random();
      for (var i = 0; i < 5; i++) {
        _loadedDreams.add(new Dream(
            faker.lorem.words(random.nextInt(4) + 1).join(" "),
            faker.lorem.sentences(random.nextInt(40) + 1).join(),
            Uuid().v4()));
      }
    } */

    setState(() {
      allDreams = _loadedDreams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLifecycleReactor(Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appName),
      ),
      body: _buildDreamList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddDream,
        tooltip: AppLocalizations.of(context).addDream,
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
          padding: EdgeInsets.only(top: 10),
          child: Text(DateFormat.yMMMMd(Localizations.localeOf(context).languageCode).format(dream.date) + "\n\n" + dream.content),
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
              title: Text(AppLocalizations.of(context).confirm),
              content: Text(AppLocalizations.of(context).confirmDeleteDream),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(AppLocalizations.of(context).cancel.toUpperCase()),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(AppLocalizations.of(context).delete.toUpperCase()),
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
          allDreams.remove(dream);
          prefs.setString("allDreams", jsonEncode(allDreams));
        });
      },
      key: ValueKey(dream.id),
    );
  }

  void _pushAddDream() async {
    final result = await Navigator.pushNamed(context, "/newOrEditDream");

    if (result == null) return;

    setState(() {
      allDreams.add(result);
    });
    prefs.setString("allDreams", jsonEncode(allDreams));
  }
}
