import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:pango_lite/model/elements/account.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class ParkBloc {
  final LocalDBProxy _localDBProxy;
  final NetworkProxy _networkProxy;
  LocationData _lastLocation;
  Map _lastAreas;
  Car car;
  ParkBloc(this._localDBProxy, this._networkProxy);

  Future get currentLocation async {
    try {
      var location = Location();
      _lastLocation = await location.getLocation();
    } on PlatformException catch (_) {}
  }

  ParkBlocState get state {
    return ParkBlocState.notParking;
  }

  Future<Account> get _account async {
    final data = await _localDBProxy.loadAccount();
    return Account(data);
  }

  Future<ParkBlocState> areas() async {
    final Account account = await _account;
    final data = await _networkProxy.sendAreas(
        account.phone,
        account.loginCar.number,
        _lastLocation.latitude.toString(),
        _lastLocation.longitude.toString(),
        account.company);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        _lastAreas = jsonDecode(data[NetworkProxyKeys.body]);
        return ParkBlocState.areas;
      default:
        return ParkBlocState.none;
    }
  }
}

enum ParkBlocState { none, parking, notParking, areas }
