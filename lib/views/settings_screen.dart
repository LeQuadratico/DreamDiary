import 'package:dream_diary/views/nav_drawer.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      drawer: NavDrawer(),
      body: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 100,
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Delete all dreams"),
                    subtitle: Text(
                        "This is permanent. You cannot restore your dreams afterwards!"),
                    leading: Icon(Icons.delete_forever),
                    hoverColor: Colors.red,
                    focusColor: Colors.red,
                    selectedTileColor: Colors.red,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Text(
              "© David Leukert 2021",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
