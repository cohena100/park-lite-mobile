import 'dart:convert';

import 'package:location/location.dart';
import 'package:pango_lite/model/elements/account.dart';
import 'package:pango_lite/model/elements/areas.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/city.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class ParkBloc {
  final LocalDBProxy _localDBProxy;
  final NetworkProxy _networkProxy;
  final LocationProxy _locationProxy;
  Areas lastAreas;
  LocationData _lastLocation;
  Car car;
  City currentCity;

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
        account.id,
        _lastLocation.latitude.toString(),
        _lastLocation.longitude.toString(),


        account.company,
        account.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        lastAreas = Areas(jsonDecode(data[NetworkProxyKeys.body]));
        return ParkBlocState.areas;
      default:
        return ParkBlocState.none;
    }
  }
}

enum ParkBlocState { none, parking, notParking, areas }
