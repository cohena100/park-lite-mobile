import 'package:pango_lite/model/elements/account.dart';

enum LocalDBProxyKeys {
  account,
}

abstract class LocalDBProxyProvider {
  Account loadAccount();
  saveAccount(Account account);
}

class LocalDBProxy implements LocalDBProxyProvider {
  final Map _db = {};

  Account loadAccount() {
    return _db[LocalDBProxyKeys.account];
  }

  saveAccount(Account account) {
    _db[LocalDBProxyKeys.account] = account;
  }
}
