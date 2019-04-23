import 'dart:convert';

import 'package:location/location.dart';
import 'package:pango_lite/model/elements/Rate.dart';
import 'package:pango_lite/model/elements/areas.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/city.dart';
import 'package:pango_lite/model/elements/parking.dart';
import 'package:pango_lite/model/elements/user.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class ParkBloc {
  final LocalDBProxy _localDBProxy;
  final NetworkProxy _networkProxy;
  final LocationProxy _locationProxy;
  Areas areas;
  LocationData location;
  Car car;
  City city;
  Rate rate;

  ParkBloc(this._localDBProxy, this._networkProxy, this._locationProxy);

  Future get currentLocation async {
    location = await _locationProxy.currentLocation;
  }

  Future<Parking> get parking async {
    final data = await _localDBProxy.loadParking();
    if (data == null) {
      return null;
    }
    return Parking(data);
  }

  Future<ParkBlocState> get state async {
    final isParking = await parking;
    if (isParking != null) {
      return ParkBlocState.parking;
    }
    return ParkBlocState.notParking;
  }

  Future<User> get _account async {
    final data = await _localDBProxy.loadUser();
    return User(data);
  }

  Future<ParkBlocState> parkingAreas() async {
    final account = await _account;
    final data = await _networkProxy.sendAreas(
        account.id,
        location.latitude.toString(),
        location.longitude.toString(),
        account.company,
        account.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        areas = Areas(jsonDecode(data[NetworkProxyKeys.body]));
        return ParkBlocState.areas;
      default:
        return ParkBlocState.none;
    }
  }

  Future<ParkBlocState> parkingStart() async {
    final account = await _account;
    final data = await _networkProxy.sendStart(
        account.id,
        car.id,
        location.latitude.toString(),
        location.longitude.toString(),
        city.id.toString(),
        city.name,
        rate.id.toString(),
        rate.name,
        car.number,
        account.company,
        account.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _localDBProxy.saveParking(data[NetworkProxyKeys.body]);
        return ParkBlocState.started;
      default:
        return ParkBlocState.none;
    }
  }
}

enum ParkBlocState { none, parking, notParking, areas, started }
