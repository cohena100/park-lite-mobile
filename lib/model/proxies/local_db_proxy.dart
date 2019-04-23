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

  Future<File> get _parkingFile async {
    final path = await _localPath;
    return File('$path/parking.json');
  }

  Future<File> get _userFile async {
    final path = await _localPath;
    return File('$path/user.json');
  }

  Future<Map> loadParking() async {
    var cache = _db[LocalDBProxyKeys.parking];
    if (cache != null) {
      return cache;
    }
    try {
      final file = await _parkingFile;
      if (file.existsSync() == false) {
        return null;
      }
      final json = await file.readAsString();
      cache = jsonDecode(json);
      _db[LocalDBProxyKeys.parking] = cache;
      return cache;
    } catch (e) {
      return null;
    }
  }

  Future<Map> loadUser() async {
    var cache = _db[LocalDBProxyKeys.user];
    if (cache != null) {
      return cache;
    }
    try {
      final file = await _userFile;
      if (file.existsSync() == false) {
        return null;
      }
      final json = await file.readAsString();
      cache = jsonDecode(json);
      _db[LocalDBProxyKeys.user] = cache;
      return cache;
    } catch (e) {
      return null;
    }
  }

  Future saveParking(String json) async {
    try {
      await _writeParking(json);
      _db[LocalDBProxyKeys.parking] = jsonDecode(json);
    } catch (e) {}
  }

  Future saveUser(String json) async {
    try {
      await _writeUser(json);
      _db[LocalDBProxyKeys.user] = jsonDecode(json);
    } catch (e) {}
  }

  Future<File> _writeParking(String json) async {
    final file = await _parkingFile;
    return file.writeAsString(json);
  }

  Future<File> _writeUser(String json) async {
    final file = await _userFile;
    return file.writeAsString(json);
  }
}

enum LocalDBProxyKeys {
  user,
  parking,
}
