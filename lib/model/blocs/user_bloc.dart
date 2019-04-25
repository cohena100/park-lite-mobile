import 'dart:async';
import 'dart:convert';

import 'package:pango_lite/model/blocs/base_bloc.dart';
import 'package:pango_lite/model/elements/user.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class UserBloc with BaseBloc {
  final NetworkProxy _networkProxy;
  final LocalDBProxy _localDBProxy;

  String phone;
  String number;
  String nickname;
  String code;

  UserBloc(this._networkProxy, this._localDBProxy);

  Future<User> get user async {
    return await getUser(_localDBProxy);
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
        final user = User.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
        await _localDBProxy.saveUser(user.toJson());
        return UserBlocState.loggedIn;
      default:
        return UserBlocState.notLoggedIn;
    }
  }

  Future<UserBlocState> userValidate() async {
    return UserBlocState.loggedIn;
  }
}

enum UserBlocState { notLoggedIn, loggedIn, validate }
