enum LocalDBProxyKeys {
  token,
}

abstract class LocalDBProxyProvider {
  String loadToken();
}

class LocalDBProxy implements LocalDBProxyProvider {
  final Map _db = {};

  String loadToken() {
    return _db[LocalDBProxyKeys.token];
  }
}
