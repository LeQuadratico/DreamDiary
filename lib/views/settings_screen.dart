import 'dart:convert';
import 'dart:io';

import 'package:dream_diary/views/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_lifecycle_reactor.dart';
import '../globals.dart' as globals;
import '../main.dart';

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
    return AppLifecycleReactor(Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      drawer: NavDrawer(),
      body: ListView(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context).export),
            subtitle: Text(AppLocalizations.of(context).exportDreams),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_sharp,
                ),
              ],
            ),
            onTap: () async {
              final dreamsEncoded = jsonEncode(allDreams);
              final path =
                  await getTemporaryDirectory().then((value) => value.path);
              final file = File("$path/dreams_export.json");
              file.writeAsString(dreamsEncoded);

              final params = SaveFileDialogParams(
                sourceFilePath: file.path,
              );
              final filePath = await FlutterFileDialog.saveFile(params: params);
              print(filePath);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).import),
            subtitle: Text(AppLocalizations.of(context).importDreams),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.download_sharp,
                ),
              ],
            ),
            onTap: () async {
              final params = OpenFileDialogParams(
                dialogType: OpenFileDialogType.document,
                sourceType: SourceType.photoLibrary,
              );
              final filePath = await FlutterFileDialog.pickFile(params: params);

              var _loadedDreams = <Dream>[];
              final file = File(filePath);
              final dreamsEncoded = await file.readAsString();
              if (dreamsEncoded != null) {
                var _dynamicList = jsonDecode(dreamsEncoded);
                _dynamicList.forEach((dynamic item) => {
                      if (item != null)
                        _loadedDreams.add(Dream(item["title"], item["content"],
                            item["id"], DateTime.parse(item["date"])))
                    });
              }
              setState(() {
                globals.secureStorageManager.replaceAllDreams(_loadedDreams);
              });
            },
          ),
          Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context).dreamSortOrder),
            subtitle:
                Text(AppLocalizations.of(context).dreamSortOrderDescription),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sort,
                ),
              ],
            ),
            trailing: DropdownButton(
              value: globals.sortMode,
              items: [
                DropdownMenuItem(
                  value: "newFirst",
                  child: Text(AppLocalizations.of(context).newFirst),
                ),
                DropdownMenuItem(
                  value: "oldFirst",
                  child: Text(AppLocalizations.of(context).oldFirst),
                )
              ],
              onChanged: (value) async {
                setState(() {
                  globals.sortMode = value;
                });

                final prefs = await SharedPreferences.getInstance();
                prefs.setString("sortMode", value);
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context).deleteAllDreams),
            subtitle:
                Text(AppLocalizations.of(context).deleteAllDreamsDescription),
            leading: Icon(Icons.delete_forever),
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
                        child: Text(
                            AppLocalizations.of(context).cancel.toUpperCase()),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(AppLocalizations.of(context)
                            .deleteAll
                            .toUpperCase()),
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
                  /* allDreams.clear(); */
                  globals.secureStorageManager.removeAllDreams();
                });

                final snackBar = SnackBar(
                  content: Text(AppLocalizations.of(context).allDreamsDeleted),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              AppLocalizations.of(context).version + " $versionName",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    ));
  }
}
