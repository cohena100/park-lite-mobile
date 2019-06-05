import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class AppContext {
  final Map data;
  final AppContextState state;
  AppContext(
      {this.data = const {}, this.state = AppContextState.none});
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

enum AppState {
  notLoggedIn,
  loggedIn,
  success,
  failure,
  authorize,
}

class LocalDbProxy {
  final bool inMemory;
  String inMemoryUser;
  String inMemoryCache;
  Map geoPark;
  AppContext appContext = AppContext();

  LocalDbProxy({this.inMemory = false});

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

  Future<Map> loadCache() async {
    if (inMemory) {
      if (inMemoryCache == null) {
        return null;
      }
      return jsonDecode(inMemoryCache);
    } else {
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
  }

  Future<Map> loadGeoPark() async {
    if (geoPark != null) {
      return geoPark;
    }
    final json = await rootBundle.loadString('data/geoPark.json');
    geoPark = jsonDecode(json);
    return geoPark;
  }

  Future<Map> loadUser() async {
    if (inMemory) {
      if (inMemoryUser == null) {
        return null;
      }
      return jsonDecode(inMemoryUser);
    } else {
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
  }

  Future saveCache(String json) async {
    if (inMemory) {
      inMemoryCache = json;
    } else {
      try {
        await _writeCache(json);
      } catch (e) {}
    }
  }

  Future saveUser(String json) async {
    if (inMemory) {
      inMemoryUser = json;
    } else {
      try {
        await _writeUser(json);
      } catch (e) {}
    }
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
