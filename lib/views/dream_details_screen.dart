import 'dart:convert';

import 'package:flutter/material.dart';

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
    return Scaffold(
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
                dream.content,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _editDream,
        tooltip: "Edit Dream",
        child: Icon(Icons.edit),
      ),
    );
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