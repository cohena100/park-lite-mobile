import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';

class ParkBloc {
  final LocalDBProxy _localDBProxy;
  LocationData lastLocation;
  ParkBloc(this._localDBProxy);

  Future get currentLocation async {
    try {
      var location = Location();
      lastLocation = await location.getLocation();
    } on PlatformException catch (_) {}
  }

  ParkBlocState get state {
    return ParkBlocState.notParking;
  }

  void foo() {
    _localDBProxy.loadAccount();
  }
}

enum ParkBlocState { none, parking, notParking }
