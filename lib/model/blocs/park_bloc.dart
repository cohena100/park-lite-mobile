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

  void _startBluetooth() {
    if (_bluetoothStateStream != null) {
      return;
    }
    _bluetoothStateStream = _bluetoothProxy.stream.listen((bool data) async {
      final user = await getUser(_localDBProxy);
      final aParking = await parking;
      final parkingCar = user.parkingCar;
      final title = '${parkingCar.nickname} ${parkingCar.number}';
      final body =
          '${aParking.cityName} ${aParking.areaName} ${aParking.rateName}';
      _notificationProxy.showNotification(title, body);
    });
  }

  void _stopBluetooth() {
    if (_bluetoothStateStream == null) {
      return;
    }
    _bluetoothStateStream.cancel();
    _bluetoothStateStream = null;
  }

  Future<Parking> get parking async {
    final user = await getUser(_localDBProxy);
    if (user.parking == null) {
      _stopBluetooth();
      return null;
    }
    _startBluetooth();
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
        final user = await getUser(_localDBProxy);
        user.updateParking(
            Parking.fromJson(jsonDecode(data[NetworkProxyKeys.body])));
        _localDBProxy.saveUser(jsonEncode(user));
        _startBluetooth();
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
        final user = await getUser(_localDBProxy);
        user.deleteParking();
        _localDBProxy.saveUser(jsonEncode(user));
        _stopBluetooth();
        return ParkBlocState.success;
      default:
        return ParkBlocState.none;
    }
  }
}

enum ParkBlocState {
  none,
  parking,
  notParking,
  areas,
  success,
}
