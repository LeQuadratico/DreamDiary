import 'dart:convert';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var _allDreams = <Dream>[];
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
        accentColor: Colors.blueGrey,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        accentColor: Colors.blueGrey,
      ),
      themeMode: ThemeMode.system,
      initialRoute: "/",
      routes: {
        "/": (context) => DreamListScreen(),
        "/newDream": (context) => AddDreamScreen(),
      },
    );
  }
}

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

  loadData() async {
    prefs = await SharedPreferences.getInstance();
    final dreamsEncoded = prefs.getString("allDreams");

    var _loadedDreams = <Dream>[];

    if (dreamsEncoded != null) {
      var _dynamicList = jsonDecode(dreamsEncoded);
      _dynamicList.forEach((dynamic item) => {
            _loadedDreams.add(Dream(item["title"], item["content"], item["id"]))
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
      _allDreams = _loadedDreams;
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
        itemCount: _allDreams.length,
        itemBuilder: (context, index) {
          return _buildRow(_allDreams[index]);
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
          _allDreams.remove(dream);
          prefs.setString("allDreams", jsonEncode(_allDreams));
        });
      },
      key: ValueKey(dream.id),
    );
  }

  void _pushAddDream() async {
    final result = await Navigator.pushNamed(context, "/newDream");

    setState(() {
      _allDreams.add(result);
    });
    prefs.setString("allDreams", jsonEncode(_allDreams));
  }
}

class AddDreamScreen extends StatefulWidget {
  @override
  _AddDreamScreenState createState() => _AddDreamScreenState();
}

class _AddDreamScreenState extends State<AddDreamScreen> {
  final _formKey = GlobalKey<FormState>();
  Dream newDream = new Dream("Empty", "Empty", Uuid().v4());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Dream",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val) => newDream.title = val,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  /*  minLines: 5, */
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Content",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val) => newDream.content = val,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Navigator.pop(context, newDream);
                    }
                  },
                  child: Text('Save Dream'),
                ),
              ],
            ),
          ),
        ),
      ),
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
