import 'package:dream_diary/main.dart';
import 'package:dream_diary/views/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var versionName = "loading...";

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      /* String appName = packageInfo.appName;
      String packageName = packageInfo.packageName; */
      setState(() {
        versionName = packageInfo.version;
      });
      /* String buildNumber = packageInfo.buildNumber; */
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      drawer: NavDrawer(),
      body: ListView(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context).deleteAllDreams),
            subtitle: Text(
                AppLocalizations.of(context).deleteAllDreamsDescription),
            leading: Icon(Icons.delete_forever),
            hoverColor: Colors.red,
            focusColor: Colors.red,
            selectedTileColor: Colors.red,
            onTap: () async {
              bool delete = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context).confirm),
                    content: Text(
                        AppLocalizations.of(context).confirmDeleteAllDreams),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(AppLocalizations.of(context).cancel.toUpperCase()),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(AppLocalizations.of(context).deleteAll.toUpperCase()),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (delete != null && delete) {
                setState(() {
                  allDreams.clear();
                });

                final prefs = await SharedPreferences.getInstance();
                prefs.remove('allDreams');

                final snackBar = SnackBar(
                  content: Text(AppLocalizations.of(context).allDreamsDeleted),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).version + " $versionName",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }
}
