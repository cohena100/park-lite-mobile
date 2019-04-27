import 'dart:async';
import 'dart:convert';

import 'package:pango_lite/model/blocs/base_bloc.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/user.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class UserBloc with BaseBloc {
  final NetworkProxy _networkProxy;
  final LocalDBProxy _localDBProxy;

  UserBlocContext context = UserBlocContext();

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
    final phone = context.data[UserBlocContextDataKey.phone];
    final number = context.data[UserBlocContextDataKey.number];
    final nickname = context.data[UserBlocContextDataKey.nickname];
    final data = await _networkProxy.sendLogin(phone, number, nickname);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        final user = User.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
        await _localDBProxy.saveUser(jsonEncode(user));
        return UserBlocState.loggedIn;
      default:
        return UserBlocState.notLoggedIn;
    }
  }

  Future<UserBlocState> addCar() async {
    final theUser = await user;
    final number = context.data[UserBlocContextDataKey.number];
    final nickname = context.data[UserBlocContextDataKey.nickname];
    final data = await _networkProxy.sendAdd(
        theUser.id, number, nickname, theUser.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        final car = Car.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
        theUser.addCar(car);
        await _localDBProxy.saveUser(jsonEncode(theUser));
        return UserBlocState.success;
      default:
        return UserBlocState.fail;
    }
  }

  Future<UserBlocState> userValidate() async {
    return UserBlocState.loggedIn;
  }
}

class UserBlocContext {
  final Map data;
  final UserBlocContextState state;
  UserBlocContext(
      {this.data = const {}, this.state = UserBlocContextState.none});
}

enum UserBlocContextDataKey { phone, number, nickname, code }

enum UserBlocContextState {
  none,
  login,
  addCar,
}

enum UserBlocState {
  notLoggedIn,
  loggedIn,
  validate,
  success,
  fail,
}
