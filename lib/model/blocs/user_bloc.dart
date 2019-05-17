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

  Future<UserBlocState> addCar() async {
    final theUser = await user;
    final data = await _networkProxy.sendAdd(theUser.id, theUser.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.validate:
        _handleAddCarValidate(data);
        return UserBlocState.validate;
      default:
        return UserBlocState.fail;
    }
  }

  Future<UserBlocState> addCarValidate() async {
    final theUser = await user;
    final number = context.data[UserBlocContextDataKey.number];
    final nickname = context.data[UserBlocContextDataKey.nickname];
    final validateId = context.data[UserBlocContextDataKey.validateId];
    final code = context.data[UserBlocContextDataKey.code];
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
      default:
        return UserBlocState.fail;
    }
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
    final Car car = context.data[UserBlocContextDataKey.car];
    final data = await _networkProxy.sendRemove(
      theUser.id,
      car.id,
      theUser.token,
    );
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _handleRemoveCarSuccess(data, theUser, car);
        return UserBlocState.success;
      default:
        return UserBlocState.fail;
    }
  }

  Future<UserBlocState> userLogin() async {
    final phone = context.data[UserBlocContextDataKey.phone];
    final data = await _networkProxy.sendLogin(phone);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.validate:
        _handleUseLoginValidate(data);
        return UserBlocState.validate;
      default:
        return UserBlocState.fail;
    }
  }

  Future<UserBlocState> userLogout() async {
    final theUser = await user;
    final data = await _networkProxy.sendLogout(theUser.id, theUser.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
      case NetworkProxy.error:
        await _handleUserLogoutSuccess(data, theUser);
        return UserBlocState.success;
      default:
        return UserBlocState.fail;
    }
  }

  Future<UserBlocState> userValidate() async {
    final userId = context.data[UserBlocContextDataKey.userId];
    final validateId = context.data[UserBlocContextDataKey.validateId];
    final code = context.data[UserBlocContextDataKey.code];
    final data = await _networkProxy.sendLoginValidate(
      userId,
      validateId,
      code,
    );
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _handleUserValidateSuccess(data);
        return UserBlocState.success;
      default:
        return UserBlocState.fail;
    }
  }

  void _handleAddCarValidate(Map data) {
    final validate = jsonDecode(data[NetworkProxyKeys.body]);
    context.data[UserBlocContextDataKey.validateId] =
        validate['validate']['validateId'];
  }

  Future _handleAddCarValidateSuccess(Map data, User user) async {
    final car = Car.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
    user.addCar(car);
    await _localDBProxy.saveUser(jsonEncode(user));
  }

  Future _handleRemoveCarSuccess(Map data, User user, Car car) async {
    user.removeCar(car);
    await _localDBProxy.saveUser(jsonEncode(user));
  }

  void _handleUseLoginValidate(Map data) {
    final validate = jsonDecode(data[NetworkProxyKeys.body]);
    context.data[UserBlocContextDataKey.userId] =
        validate['validate']['userId'];
    context.data[UserBlocContextDataKey.validateId] =
        validate['validate']['validateId'];
  }

  Future _handleUserLogoutSuccess(Map data, User user) async {
    user.deleteToken();
    await _localDBProxy.saveUser(jsonEncode(user));
  }

  Future _handleUserValidateSuccess(Map data) async {
    final user = User.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
    await _localDBProxy.saveUser(jsonEncode(user));
  }
}

class UserBlocContext {
  final Map data;
  final UserBlocContextState state;
  UserBlocContext(
      {this.data = const {}, this.state = UserBlocContextState.none});
}

enum UserBlocContextDataKey {
  phone,
  number,
  nickname,
  code,
  car,
  userId,
  validateId,
}

enum UserBlocContextState {
  none,
  login,
  addCar,
  removeCar,
}

enum UserBlocState {
  notLoggedIn,
  loggedIn,
  validate,
  success,
  fail,
}
