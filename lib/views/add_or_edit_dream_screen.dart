import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class AddOrEditDreamScreen extends StatefulWidget {
  @override
  _AddOrEditDreamScreenState createState() => _AddOrEditDreamScreenState();
}

class _AddOrEditDreamScreenState extends State<AddOrEditDreamScreen> {
  final _formKey = GlobalKey<FormState>();
  Dream newDream;

  @override
  Widget build(BuildContext context) {
    newDream = ModalRoute.of(context).settings.arguments;
    if (newDream == null) newDream = new Dream("", "", Uuid().v4(), DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add/Edit Dream",
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
                  initialValue: newDream.title,
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
                  initialValue: newDream.content,
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
                /* SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Navigator.pop(context, newDream);
                    }
                  },
                  child: Text('Save Dream'),
                ), */
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveDream,
        tooltip: "Save Dream",
        child: Icon(Icons.save),
      ),
    );
  }

  void saveDream() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      newDream.date = DateTime.now();
      Navigator.pop(context, newDream);
    }
  }
}
