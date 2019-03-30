import 'dart:async';
import 'package:pango_lite/model/proxies/network_proxy.dart';

enum AccountBlocState { notLoggedIn }

class AccountBloc {
  final NetworkProxyProvider _networkProxy;

  AccountBloc(this._networkProxy);

  Future login() async {
    await _networkProxy.login('phone', 'car');
    return AccountBlocState.notLoggedIn;
  }
}
