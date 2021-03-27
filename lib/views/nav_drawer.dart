import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                AppLocalizations.of(context).appName,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).dreamList),
            leading: Icon(Icons.list),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context).settings.name != "/dreamList")
                Navigator.pushReplacementNamed(context, "/dreamList");
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).addDream),
            leading: Icon(Icons.add_circle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/dreamList", arguments: true);
            },
          ),
          Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context).settings),
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
