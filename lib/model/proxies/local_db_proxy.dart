import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalDBProxy {
  final Map _db = {};

  Future get _accountFile async {
    final path = await _localPath;
    return File('$path/account.json');
  }

  Future get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future loadAccount() async {
    var cache = _db[LocalDBProxyKeys.account];
    if (cache != null) {
      return cache;
    }
    try {
      final accountFile = await _accountFile;
      if (accountFile.existsSync() == false) {
        return null;
      }
      cache = await accountFile.readAsString();
      _db[LocalDBProxyKeys.account] = cache;
      return cache;
    } catch (e) {
      return null;
    }
  }

  Future saveAccount(String account) async {
    try {
      await _writeAccount(account);
      _db[LocalDBProxyKeys.account] = account;
    } catch (e) {}
  }

  Future<File> _writeAccount(String account) async {
    final file = await _accountFile;
    return file.writeAsString(account);
  }
}

enum LocalDBProxyKeys {
  account,
}
