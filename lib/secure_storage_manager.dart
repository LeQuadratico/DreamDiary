import 'dart:convert';

import 'main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  final storage = new FlutterSecureStorage();
  var _loadedDreams = <Dream>[];

  loadList() async {
    final dreamsEncoded = await storage.read(key: "dreams");

    if (dreamsEncoded != null) {
      var _dynamicList = jsonDecode(dreamsEncoded);
      _dynamicList.forEach((dynamic item) => {
            if (item != null)
              _loadedDreams.add(Dream(item["title"], item["content"],
                  item["id"], DateTime.parse(item["date"])))
          });
    }
  }

  getAllDreams() {
    return _loadedDreams;
  }

  addDream(Dream dream) {
    _loadedDreams.add(dream);
    saveCurrentList();
  }

  removeDream(Dream dream) {
    _loadedDreams.remove(dream);
    saveCurrentList();
  }

  removeAllDreams() {
    _loadedDreams.clear();
    saveCurrentList();
  }

  replaceDream(Dream oldDream, Dream newDream) {
    final index = _loadedDreams.indexOf(oldDream);
    _loadedDreams.remove(oldDream);
    _loadedDreams.insert(index, newDream);
    saveCurrentList();
  }

  saveCurrentList() {
    storage.write(key: "dreams", value: jsonEncode(_loadedDreams));
  }
}
