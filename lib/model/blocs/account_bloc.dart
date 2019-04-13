import 'dart:async';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/model/elements/account.dart';

enum AccountBlocState { notLoggedIn, loggedIn }

class AccountBloc {
  final NetworkProxyProvider _networkProxy;
  final LocalDBProxyProvider _localDBProxy;

  String phone;
  String number;

  AccountBloc(this._networkProxy, this._localDBProxy);

  AccountBlocState handshake() {
    if (_localDBProxy.loadAccount() == null) {
      return AccountBlocState.notLoggedIn;
    } else {
      return AccountBlocState.loggedIn;
    }
  }

  Future login() async {
    final data = await _networkProxy.login(phone, number);
    if (data == null) {
      return AccountBlocState.notLoggedIn;
    } else {
      _localDBProxy.saveAccount(Account(data));
      return AccountBlocState.loggedIn;
    }
  }
}
