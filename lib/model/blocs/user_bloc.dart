import 'dart:async';
import 'dart:convert';

import 'package:pango_lite/model/blocs/base_bloc.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/user.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class UserBloc with BaseBloc {
  final NetworkProxy _networkProxy;
  final LocalDbProxy _localDbProxy;

  UserBloc(this._networkProxy, this._localDbProxy);

  bool get isInTestMode {
    return _localDbProxy.inMemoryUser != null;
  }

  Future<User> get user async {
    return await getUser(_localDbProxy);
  }

  Future<UserBlocState> addCar() async {
    final theUser = await user;
    final data = await _networkProxy.sendAdd(theUser.id, theUser.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        _handleAddCarSuccess(data);
        return UserBlocState.success;
      case NetworkProxy.authorize:
        return UserBlocState.authorize;
    }
    return UserBlocState.failure;
  }

  Future<UserBlocState> addCarValidate() async {
    final theUser = await user;
    final number = _localDbProxy.appContext.data[AppContextDataKey.number];
    final nickname = _localDbProxy.appContext.data[AppContextDataKey.nickname];
    final validateId =
        _localDbProxy.appContext.data[AppContextDataKey.validateId];
    final code = _localDbProxy.appContext.data[AppContextDataKey.code];
    final data = await _networkProxy.sendAddValidate(
      theUser.id,
      number,
      nickname,
      validateId,
      code,
      theUser.token,
    );
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _handleAddCarValidateSuccess(data, theUser);
        return UserBlocState.success;
      case NetworkProxy.authorize:
        return UserBlocState.authorize;
    }
    return UserBlocState.failure;
  }

  Future<UserBlocState> handshake() async {
    final isUser = await user;
    if (isUser == null || isUser.token == null) {
      return UserBlocState.notLoggedIn;
    }
    return UserBlocState.loggedIn;
  }

  Future<UserBlocState> removeCar() async {
    final theUser = await user;
    final Car car = _localDbProxy.appContext.data[AppContextDataKey.car];
    final data = await _networkProxy.sendRemove(
      theUser.id,
      car.id,
      theUser.token,
    );
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _handleRemoveCarSuccess(data, theUser, car);
        return UserBlocState.success;
      case NetworkProxy.authorize:
        return UserBlocState.authorize;
    }
    return UserBlocState.failure;
  }

  Future<UserBlocState> userLogin() async {
    final phone = _localDbProxy.appContext.data[AppContextDataKey.phone];
    final data = await _networkProxy.sendLogin(phone);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        _handleUserLoginSuccess(data);
        return UserBlocState.success;
    }
    return UserBlocState.failure;
  }

  Future<UserBlocState> userLogout({bool isForced = false}) async {
    final theUser = await user;
    if (!isForced) {
      await _networkProxy.sendLogout(theUser.id, theUser.token);
    }
    await _handleUserLogout(theUser);
    return UserBlocState.success;
  }

  Future<UserBlocState> userValidate() async {
    final userId = _localDbProxy.appContext.data[AppContextDataKey.userId];
    final validateId =
        _localDbProxy.appContext.data[AppContextDataKey.validateId];
    final code = _localDbProxy.appContext.data[AppContextDataKey.code];
    final data = await _networkProxy.sendLoginValidate(
      userId,
      validateId,
      code,
    );
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _handleUserValidateSuccess(data);
        return UserBlocState.success;
    }
    return UserBlocState.failure;
  }

  void _handleAddCarSuccess(Map data) {
    final validate = jsonDecode(data[NetworkProxyKeys.body]);
    _localDbProxy.appContext.data[AppContextDataKey.validateId] =
        validate['validate']['validateId'];
  }

  Future _handleAddCarValidateSuccess(Map data, User user) async {
    final car = Car.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
    user.addCar(car);
    await _localDbProxy.saveUser(jsonEncode(user));
  }

  Future _handleRemoveCarSuccess(Map data, User user, Car car) async {
    user.removeCar(car);
    await _localDbProxy.saveUser(jsonEncode(user));
  }

  void _handleUserLoginSuccess(Map data) {
    final validate = jsonDecode(data[NetworkProxyKeys.body]);
    _localDbProxy.appContext.data[AppContextDataKey.userId] =
        validate['validate']['userId'];
    _localDbProxy.appContext.data[AppContextDataKey.validateId] =
        validate['validate']['validateId'];
  }

  Future _handleUserLogout(User user) async {
    user.deleteToken();
    await _localDbProxy.saveUser(jsonEncode(user));
  }

  Future _handleUserValidateSuccess(Map data) async {
    final user = User.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
    await _localDbProxy.saveUser(jsonEncode(user));
  }
}

enum UserBlocState {
  notLoggedIn,
  loggedIn,
  success,
  failure,
  authorize,
}
