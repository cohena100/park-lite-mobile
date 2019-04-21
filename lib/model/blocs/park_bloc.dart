import 'dart:convert';

import 'package:location/location.dart';
import 'package:pango_lite/model/elements/account.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class ParkBloc {
  final LocalDBProxy _localDBProxy;
  final NetworkProxy _networkProxy;
  final LocationProxy _locationProxy;
  LocationData _lastLocation;
  Map _lastAreas;
  Car car;
  ParkBloc(this._localDBProxy, this._networkProxy, this._locationProxy);

  Future get currentLocation async {
    _lastLocation = await _locationProxy.currentLocation;
  }

  ParkBlocState get state {
    return ParkBlocState.notParking;
  }

  Future<Account> get _account async {
    final data = await _localDBProxy.loadAccount();
    return Account(data);
  }

  Future<ParkBlocState> areas() async {
    final account = await _account;
    final data = await _networkProxy.sendAreas(
        account.phone,
        account.loginCar.number,
        _lastLocation.latitude.toString(),
        _lastLocation.longitude.toString(),
        account.company);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        _lastAreas = jsonDecode(data[NetworkProxyKeys.body]);
        return ParkBlocState.cities;
      default:
        return ParkBlocState.none;
    }
  }
}

enum ParkBlocState { none, parking, notParking, cities }
