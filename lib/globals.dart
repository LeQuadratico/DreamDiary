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

library dream_diary.globals;

import 'package:dream_diary/secure_storage_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SecureStorageManager secureStorageManager;
String? sortMode;

initGlobals() async {
  secureStorageManager = new SecureStorageManager();
  secureStorageManager.loadList();

  if (sortMode == null) {
    final prefs = await SharedPreferences.getInstance();
    sortMode = prefs.getString("sortMode") ?? "newFirst";
  }
}

Future<String> getSortMode() async {
  if (sortMode == null) {
    final prefs = await SharedPreferences.getInstance();
    sortMode = prefs.getString("sortMode") ?? "newFirst";
  }

  return sortMode!;
}
