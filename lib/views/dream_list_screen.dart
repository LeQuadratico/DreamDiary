import 'dart:convert';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class DreamListScreen extends StatefulWidget {
  final String title = "Dream Diary";

  @override
  _DreamListScreenState createState() => _DreamListScreenState();
}

class _DreamListScreenState extends State<DreamListScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
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
                  .add(Dream(item["title"], item["content"], item["id"]))
          });
    } else {
      var faker = Faker();
      var random = Random();
      for (var i = 0; i < 20; i++) {
        _loadedDreams.add(new Dream(
            faker.lorem.words(random.nextInt(4) + 1).join(" "),
            faker.lorem.sentences(random.nextInt(40) + 1).join(),
            Uuid().v4()));
      }
    }

    setState(() {
      allDreams = _loadedDreams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildDreamList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddDream,
        tooltip: 'Add Dream',
        child: Icon(Icons.add),
      ),
    );
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
          child: Text(dream.content),
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
              title: Text("Confirm"),
              content: Text(
                  "Are you sure you wish to delete this dream?\n\nIt cannot be restored afterwards!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("DELETE"),
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
