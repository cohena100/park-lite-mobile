import 'dart:async';

import 'package:pango_lite/model/elements/account.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class AccountBloc {
  final NetworkProxy _networkProxy;
  final LocalDBProxy _localDBProxy;

  String phone;
  String number;
  String nickname;
  String code;

  AccountBloc(this._networkProxy, this._localDBProxy);

  Future handshake() async {
    if (await _localDBProxy.loadAccount() == null) {
      return AccountBlocState.notLoggedIn;
    } else {
      return AccountBlocState.loggedIn;
    }
  }

  Future login() async {
    final data = await _networkProxy.sendLogin(phone, number, nickname);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _localDBProxy.saveAccount(data[NetworkProxyKeys.body]);
        return AccountBlocState.loggedIn;
      case NetworkProxy.validate:
        return AccountBlocState.validate;
      default:
        return AccountBlocState.notLoggedIn;
    }
  }

  Future validate() async {
    final data = await _networkProxy.sendValidate(phone, number, code);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _localDBProxy.saveAccount(data[NetworkProxyKeys.body]);
        return AccountBlocState.loggedIn;
      default:
        return AccountBlocState.notLoggedIn;
    }
  }

  Future get account async {
    final data = await _localDBProxy.loadAccount();
    return Account(data);
  }
}

enum AccountBlocState { notLoggedIn, loggedIn, validate }
