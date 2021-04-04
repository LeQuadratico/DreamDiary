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

  replaceAllDreams(List<Dream> newDreamList) {
    _loadedDreams.clear();
    _loadedDreams.addAll(newDreamList);
    saveCurrentList();
  }

  saveCurrentList() {
    storage.write(key: "dreams", value: jsonEncode(_loadedDreams));
  }
}
