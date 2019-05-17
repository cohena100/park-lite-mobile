import 'dart:async';
import 'dart:convert';

import 'package:location/location.dart';
import 'package:pango_lite/model/blocs/base_bloc.dart';
import 'package:pango_lite/model/elements/area.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/city.dart';
import 'package:pango_lite/model/elements/geo_park.dart';
import 'package:pango_lite/model/elements/parking.dart';
import 'package:pango_lite/model/elements/rate.dart';
import 'package:pango_lite/model/proxies/bluetooth_proxy.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/model/proxies/notification_proxy.dart';

class ParkBloc with BaseBloc {
  final LocalDBProxy _localDBProxy;
  final NetworkProxy _networkProxy;
  final LocationProxy _locationProxy;
  final BluetoothProxy _bluetoothProxy;
  final NotificationProxy _notificationProxy;
  GeoPark areas;
  LocationData location;
  Car car;
  City city;
  Area area;
  Rate rate;
  StreamSubscription _bluetoothStateStream;

  ParkBloc(
    this._localDBProxy,
    this._networkProxy,
    this._locationProxy,
    this._bluetoothProxy,
    this._notificationProxy,
  );

  Future get currentLocation async {
    location = await _locationProxy.currentLocation;
  }

  Future<Parking> get currentParking async {
    final user = await getUser(_localDBProxy);
    if (user.parking == null) {
      _stopBluetooth();
      return null;
    }
    _startBluetooth();
    return user.parking;
  }

  Future<List<Parking>> get parkings async {
    final cache = await getCache(_localDBProxy);
    return cache.parkings;
  }

  Future<ParkBlocState> get state async {
    final isParking = await currentParking;
    if (isParking != null) {
      return ParkBlocState.parking;
    }
    return ParkBlocState.notParking;
  }

  Future<ParkBlocState> parkingAreas() async {
    areas = GeoPark(_localDBProxy.loadGeoPark());
    return ParkBlocState.areas;
  }

  Future<ParkBlocState> startParking() async {
    final user = await getUser(_localDBProxy);
    final data = await _networkProxy.sendStart(
        user.id,
        car.id,
        location.latitude.toString(),
        location.longitude.toString(),
        city.id,
        city.name,
        area.id,
        area.name,
        rate.id,
        rate.name,
        user.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _handleStartParkingSuccess(data);
        return ParkBlocState.success;
      default:
        return ParkBlocState.none;
    }
  }

  Future<ParkBlocState> startPreviousParking(Parking parking, Car car) async {
    final user = await getUser(_localDBProxy);
    final data = await _networkProxy.sendStart(
        user.id,
        car.id,
        parking.lat,
        parking.lon,
        parking.cityId,
        parking.cityName,
        parking.areaId,
        parking.areaName,
        parking.rateId,
        parking.rateName,
        user.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _handleStartParkingSuccess(data);
        return ParkBlocState.success;
      default:
        return ParkBlocState.none;
    }
  }

  Future<ParkBlocState> stopParking() async {
    final user = await getUser(_localDBProxy);
    final parking = user.parking;
    final data = await _networkProxy.sendStop(user.id, parking.id, user.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _handleStopParkingSuccess(data);
        return ParkBlocState.success;
      default:
        return ParkBlocState.none;
    }
  }

  Future _handleStartParkingSuccess(Map data) async {
    final user = await getUser(_localDBProxy);
    final parking = Parking.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
    user.updateParking(parking);
    await _localDBProxy.saveUser(jsonEncode(user));
    _startBluetooth();
  }

  Future _handleStopParkingSuccess(Map data) async {
    final user = await getUser(_localDBProxy);
    user.deleteParking();
    await _localDBProxy.saveUser(jsonEncode(user));
    final cache = await getCache(_localDBProxy);
    final parking = Parking.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
    cache.updateParkings(parking);
    await _localDBProxy.saveCache(jsonEncode(cache));
    _stopBluetooth();
  }

  void _startBluetooth() {
    if (_bluetoothStateStream != null) {
      return;
    }
    _bluetoothStateStream = _bluetoothProxy.stream.listen((bool data) async {
      final user = await getUser(_localDBProxy);
      final aParking = await currentParking;
      final parkingCar = user.parkingCar;
      final title = '${parkingCar.nickname} ${parkingCar.number}';
      final b =
          '${aParking.cityName} ${aParking.areaName} ${aParking.rateName}';
      _notificationProxy.showNotification(title, b);
    });
  }

  void _stopBluetooth() {
    if (_bluetoothStateStream == null) {
      return;
    }
    _bluetoothStateStream.cancel();
    _bluetoothStateStream = null;
  }
}

enum ParkBlocState {
  none,
  parking,
  notParking,
  areas,
  success,
}
