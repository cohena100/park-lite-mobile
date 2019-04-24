import 'dart:convert';

import 'package:location/location.dart';
import 'package:pango_lite/model/elements/rate.dart';
import 'package:pango_lite/model/elements/areas.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/city.dart';
import 'package:pango_lite/model/elements/parking.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/model/blocs/base_bloc.dart';

class ParkBloc with BaseBloc {
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
    final user = await getUser(_localDBProxy);
    if (user.parking == null) {
      return null;
    }
    return user.parking;
  }

  Future<ParkBlocState> get state async {
    final isParking = await parking;
    if (isParking != null) {
      return ParkBlocState.parking;
    }
    return ParkBlocState.notParking;
  }

  Future<ParkBlocState> parkingAreas() async {
    final user = await getUser(_localDBProxy);
    final data = await _networkProxy.sendAreas(
        user.id,
        location.latitude.toString(),
        location.longitude.toString(),
        user.company,
        user.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        areas = Areas(jsonDecode(data[NetworkProxyKeys.body]));
        return ParkBlocState.areas;
      default:
        return ParkBlocState.none;
    }
  }

  Future<ParkBlocState> startParking() async {
    final user = await getUser(_localDBProxy);
    final data = await _networkProxy.sendStart(
        user.id,
        car.id,
        location.latitude.toString(),
        location.longitude.toString(),
        city.id.toString(),
        city.name,
        rate.id.toString(),
        rate.name,
        car.number,
        user.company,
        user.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        final user = await getUser(_localDBProxy);
        user.updateParking(Parking(data[NetworkProxyKeys.body]));
        _localDBProxy.saveUser(user.toJson());
        return ParkBlocState.success;
      default:
        return ParkBlocState.none;
    }
  }

  Future<ParkBlocState> stopParking() async {
    final user = await getUser(_localDBProxy);
    final parking = user.parking;
    final data = await _networkProxy.sendStop(
        user.id,
        parking.carId,
        parking.id,
        parking.lat,
        parking.lon,
        parking.cityId,
        parking.rateId,
        user.findCar(parking.carId).number,
        user.company,
        user.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        final user = await getUser(_localDBProxy);
        user.deleteParking();
        _localDBProxy.saveUser(jsonEncode(user));
        return ParkBlocState.success;
      default:
        return ParkBlocState.none;
    }
  }
}

enum ParkBlocState { none, parking, notParking, areas, success }
