import 'dart:async';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/model/elements/account.dart';

enum AccountBlocState { notLoggedIn, loggedIn, verification }

class AccountBloc {
  final NetworkProxy _networkProxy;
  final LocalDBProxy _localDBProxy;

  String phone;
  String number;
  String nickname;
  String verification;

  AccountBloc(this._networkProxy, this._localDBProxy);

  AccountBlocState handshake() {
    if (_localDBProxy.loadAccount() == null) {
      return AccountBlocState.notLoggedIn;
    } else {
      return AccountBlocState.loggedIn;
    }
  }

  Future login() async {
    final data = await _networkProxy.login(phone, number, nickname) as Map;
    switch (data[NetworkProxyKeys.code] as int) {
      case 200:
        _localDBProxy.saveAccount(Account(data[NetworkProxyKeys.body]));
        return AccountBlocState.loggedIn;
      case 401:
        return AccountBlocState.verification;
      default:
        return AccountBlocState.notLoggedIn;
    }
  }

  Future verify() async {
    final data = await _networkProxy.verify(phone, number, verification) as Map;
    switch (data[NetworkProxyKeys.code] as int) {
      case 200:
        _localDBProxy.saveAccount(Account(data[NetworkProxyKeys.body]));
        return AccountBlocState.loggedIn;
      default:
        return AccountBlocState.notLoggedIn;
    }
  }
}
