import 'dart:async';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

enum AccountBlocState { notLoggedIn, loggedIn }

class AccountBloc {
  final NetworkProxyProvider _networkProxy;
  final LocalDBProxyProvider _localDBProxy;

  AccountBloc(this._networkProxy, this._localDBProxy);

  Future handshake() async {
    await Future.delayed(Duration(seconds: 3));
    if (_localDBProxy.loadAccount() == null) {
      return AccountBlocState.notLoggedIn;
    } else {
      return AccountBlocState.loggedIn;
    }
  }

  Future login(String phone, String car) async {
    await _networkProxy.login(phone, car);
    return AccountBlocState.loggedIn;
  }
}
