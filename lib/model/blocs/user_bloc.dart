import 'dart:async';

import 'package:pango_lite/model/elements/user.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class UserBloc {
  final NetworkProxy _networkProxy;
  final LocalDBProxy _localDBProxy;

  String phone;
  String number;
  String nickname;
  String code;

  UserBloc(this._networkProxy, this._localDBProxy);

  Future<User> get user async {
    final data = await _localDBProxy.loadUser();
    if (data == null) {
      return null;
    }
    return User(data);
  }

  Future<UserBlocState> handshake() async {
    final isUser = await user;
    if (isUser == null) {
      return UserBlocState.notLoggedIn;
    }
    return UserBlocState.loggedIn;
  }

  Future<UserBlocState> userLogin() async {
    final data = await _networkProxy.sendLogin(phone, number, nickname);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _localDBProxy.saveUser(data[NetworkProxyKeys.body]);
        return UserBlocState.loggedIn;
      case NetworkProxy.validate:
        return UserBlocState.validate;
      default:
        return UserBlocState.notLoggedIn;
    }
  }

  Future<UserBlocState> userValidate() async {
    final data = await _networkProxy.sendValidate(phone, number, code);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _localDBProxy.saveUser(data[NetworkProxyKeys.body]);
        return UserBlocState.loggedIn;
      default:
        return UserBlocState.notLoggedIn;
    }
  }
}

enum UserBlocState { notLoggedIn, loggedIn, validate }
