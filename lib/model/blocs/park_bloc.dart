import 'dart:async';
import 'dart:convert';

import 'package:location/location.dart';
import 'package:pango_lite/model/blocs/base_bloc.dart';
import 'package:pango_lite/model/elements/area.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/city.dart';
import 'package:pango_lite/model/elements/geo_park.dart';
import 'package:pango_lite/model/elements/parking.dart';
import 'package:pango_lite/model/elements/payment.dart';
import 'package:pango_lite/model/elements/rate.dart';
import 'package:pango_lite/model/proxies/bluetooth_proxy.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/model/proxies/notification_proxy.dart';

class ParkBloc with BaseBloc {
  final LocalDbProxy _localDbProxy;
  final NetworkProxy _networkProxy;
  final LocationProxy _locationProxy;
  final BluetoothProxy _bluetoothProxy;
  final NotificationProxy _notificationProxy;
  LocationData locationData;
  StreamSubscription _bluetoothStateStream;

  ParkBloc(
    this._localDbProxy,
    this._networkProxy,
    this._locationProxy,
    this._bluetoothProxy,
    this._notificationProxy,
  );

  Future<ParkBlocState> get location async {
    locationData = await _locationProxy.location;
    if (locationData == null) {
      return ParkBlocState.failure;
    }
    return ParkBlocState.success;
  }

  Future<List<Parking>> get parkings async {
    final cache = await getCache(_localDbProxy);
    return cache.parkings.reversed.toList();
  }

  Future<ParkBlocState> get state async {
    final user = await getUser(_localDbProxy);
    if (user.parking == null) {
      _stopBluetooth();
    } else if (user.payment == null) {
      _startBluetooth();
    }
    if (user.payment != null) {
      return ParkBlocState.pay;
    }
    if (user.parking != null) {
      return ParkBlocState.parking;
    }
    return ParkBlocState.notParking;
  }

  Future completeParking() async {
    final user = await getUser(_localDbProxy);
    user.deleteParking();
    user.deletePayment();
    await _localDbProxy.saveUser(jsonEncode(user));
  }

  Future<ParkBlocState> endParking() async {
    final user = await getUser(_localDbProxy);
    final parking = user.parking;
    final data = await _networkProxy.sendEnd(user.id, parking.id, user.token);
    switch (data[NetworkProxyKeys.code]) {
      case NetworkProxy.success:
        await _handleEndParkingSuccess(data);
        return ParkBlocState.success;
      case NetworkProxy.authorize:
        return ParkBlocState.authorize;
    }
    return ParkBlocState.failure;
  }

  Future<GeoPark> geoPark() async {
    final data = await _localDbProxy.loadGeoPark();
    return GeoPark(data);
  }

  Future<ParkBlocState> startParking() async {
    final user = await getUser(_localDbProxy);
    Car car = _localDbProxy.appContext.data[AppContextDataKey.car];
    City city = _localDbProxy.appContext.data[AppContextDataKey.city];
    Area area = _localDbProxy.appContext.data[AppContextDataKey.area];
    Rate rate = _localDbProxy.appContext.data[AppContextDataKey.rate];
    final data = await _networkProxy.sendStart(
        user.id,
        car.id,
        locationData.latitude.toString(),
        locationData.longitude.toString(),
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
      case NetworkProxy.authorize:
        return ParkBlocState.authorize;
    }
    return ParkBlocState.failure;
  }

  Future<ParkBlocState> startPreviousParking(Parking parking, Car car) async {
    final user = await getUser(_localDbProxy);
    final data = await _networkProxy.sendStart(
        user.id,
        car.id,
        locationData.latitude.toString(),
        locationData.longitude.toString(),
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
      case NetworkProxy.authorize:
        return ParkBlocState.authorize;
    }
    return ParkBlocState.failure;
  }

  Future _handleEndParkingSuccess(Map data) async {
    final user = await getUser(_localDbProxy);
    final payment = Payment.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
    user.updatePayment(payment);
    await _localDbProxy.saveUser(jsonEncode(user));
    final cache = await getCache(_localDbProxy);
    final parking = Parking.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
    cache.updateParkings(parking);
    await _localDbProxy.saveCache(jsonEncode(cache));
    _stopBluetooth();
  }

  Future _handleStartParkingSuccess(Map data) async {
    final user = await getUser(_localDbProxy);
    final parking = Parking.fromJson(jsonDecode(data[NetworkProxyKeys.body]));
    user.updateParking(parking);
    await _localDbProxy.saveUser(jsonEncode(user));
    _startBluetooth();
  }

  void _startBluetooth() {
    if (_bluetoothStateStream != null) {
      return;
    }
    _bluetoothStateStream = _bluetoothProxy.stream.listen((bool data) async {
      final user = await getUser(_localDbProxy);
      final parking = user.parking;
      final car = user.parkingCar;
      final title = '${car.nickname} ${car.number}';
      final b = '${parking.cityName} ${parking.areaName} ${parking.rateName}';
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
  parking,
  notParking,
  pay,
  areas,
  success,
  failure,
  authorize,
}
