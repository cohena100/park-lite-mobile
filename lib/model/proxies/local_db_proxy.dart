import 'package:pango_lite/model/elements/account.dart';

enum LocalDBProxyKeys {
  account,
}

class LocalDBProxy {
  final Map _db = {};

  Account loadAccount() {
    return _db[LocalDBProxyKeys.account];
  }

  saveAccount(Account account) {
    _db[LocalDBProxyKeys.account] = account;
  }
}
