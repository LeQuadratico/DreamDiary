import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Dream Diary",
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text("Dream List"),
            leading: Icon(Icons.list),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context).settings.name != "/")
                Navigator.pushReplacementNamed(context, "/");
            },
          ),
          ListTile(
            title: Text("Add Dream"),
            leading: Icon(Icons.add_circle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/", arguments: true);
            },
          ),
          Divider(),
          ListTile(
            title: Text("Settings"),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context).settings.name != "/settings")
              Navigator.pushReplacementNamed(context, "/settings");
            },
          ),
        ],
      ),
    );
  }
}
