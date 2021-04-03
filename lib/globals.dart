library dream_diary.globals;

import 'package:dream_diary/secure_storage_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

SecureStorageManager secureStorageManager;
String sortMode;

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

  return sortMode;
}
