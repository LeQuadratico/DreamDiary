import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var _allDreams = <Dream>[];

void main() {
  var faker = Faker();
  var random = Random();
  for (var i = 0; i < 10; i++) {
    _allDreams.add(new Dream(faker.lorem.words(random.nextInt(4) + 1).join(" "),
        faker.lorem.sentences(random.nextInt(40) + 1).join(), Uuid().v4()));
  }

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title = "Dream Diary";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm"),
              content: Text("Are you sure you wish to delete this dream?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("DELETE")),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("CANCEL"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (dir) {
        setState(() {
          _allDreams.remove(dream);
        });
      },
      key: ValueKey(dream.id),
    );
  }

  void _pushAddDream() {
    Navigator.of(context).push(_newDiaryPage());
  }

  MaterialPageRoute<void> _newDiaryPage() {
    final _formKey = GlobalKey<FormState>();
    Dream newDream = new Dream("Empty", "Empty", Uuid().v4());
    return MaterialPageRoute<void>(builder: (BuildContext context) {
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
                        setState(() {
                          _allDreams.add(newDream);
                        });
                        Navigator.of(context).pop();
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
    });
  }
}

class Dream {
  String title;
  String content;
  String id;
  DateTime date;

  Dream(this.title, this.content, this.id);
}
