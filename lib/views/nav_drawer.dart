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
