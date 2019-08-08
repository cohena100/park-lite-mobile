import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class AppContext {
  final Map data;
  final AppContextState state;
  AppContext({this.data = const {}, this.state = AppContextState.none});
}

enum AppContextDataKey {
  phone,
  number,
  nickname,
  code,
  car,
  city,
  area,
  rate,
  userId,
  validateId,
}

enum AppContextState {
  none,
  login,
  addCar,
  removeCar,
  park,
}

class LocalDbProxy {
  Map geoPark;
  final bool isInTestModel;
  AppContext appContext = AppContext();

  LocalDbProxy({this.isInTestModel = false});

  Future<File> get _cacheFile async {
    final path = await _localPath;
    return File('$path/cache.json');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _userFile async {
    final path = await _localPath;
    return File('$path/user.json');
  }

  Future drop() async {
    try {
      final userFile = await _userFile;
      if (userFile.existsSync()) {
        userFile.deleteSync();
      }
      final cacheFile = await _cacheFile;
      if (cacheFile.existsSync()) {
        cacheFile.deleteSync();
      }
    } catch (e) {
      return;
    }
  }

  Future<Map> loadCache() async {
    try {
      final file = await _cacheFile;
      if (file.existsSync() == false) {
        return null;
      }
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }

  Future<Map> loadGeoPark() async {
    if (geoPark != null) {
      return geoPark;
    }
    final json = await rootBundle.loadString('data/geo_park.json');
    geoPark = jsonDecode(json);
    return geoPark;
  }

  Future<Map> loadUser() async {
    try {
      final file = await _userFile;
      if (file.existsSync() == false) {
        return null;
      }
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }

  Future saveCache(String json) async {
    try {
      await _writeCache(json);
    } catch (e) {}
  }

  Future saveUser(String json) async {
    try {
      await _writeUser(json);
    } catch (e) {}
  }

  Future<File> _writeCache(String json) async {
    final file = await _cacheFile;
    return file.writeAsString(json);
  }

  Future<File> _writeUser(String json) async {
    final file = await _userFile;
    return file.writeAsString(json);
  }
}
