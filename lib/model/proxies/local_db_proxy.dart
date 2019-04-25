import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalDBProxy {
  final Map _db = {};

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _userFile async {
    final path = await _localPath;
    return File('$path/user.json');
  }

  Future<Map> loadUser() async {
    final cache = _db[LocalDBProxyKeys.user];
    if (cache != null) {
      return cache;
    }
    try {
      final file = await _userFile;
      if (file.existsSync() == false) {
        return null;
      }
      final jsonString = await file.readAsString();
      _db[LocalDBProxyKeys.user] = jsonDecode(jsonString);
      return _db[LocalDBProxyKeys.user];
    } catch (e) {
      return null;
    }
  }

  Future saveUser(String json) async {
    try {
      await _writeUser(json);
      _db[LocalDBProxyKeys.user] = jsonDecode(json);
    } catch (e) {}
  }

  Future<File> _writeUser(String json) async {
    final file = await _userFile;
    return file.writeAsString(json);
  }
}

enum LocalDBProxyKeys {
  user,
}
