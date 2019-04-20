import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalDBProxy {
  final Map _db = {};

  Future<File> get _accountFile async {
    final path = await _localPath;
    return File('$path/account.json');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Map> loadAccount() async {
    var cache = _db[LocalDBProxyKeys.account];
    if (cache != null) {
      return cache;
    }
    try {
      final accountFile = await _accountFile;
      if (accountFile.existsSync() == false) {
        return null;
      }
      final json = await accountFile.readAsString();
      cache = jsonDecode(json);
      _db[LocalDBProxyKeys.account] = cache;
      return cache;
    } catch (e) {
      return null;
    }
  }

  Future saveAccount(String json) async {
    try {
      await _writeAccount(json);
      _db[LocalDBProxyKeys.account] = jsonDecode(json);
    } catch (e) {}
  }

  Future<File> _writeAccount(String json) async {
    final file = await _accountFile;
    return file.writeAsString(json);
  }
}

enum LocalDBProxyKeys {
  account,
}
