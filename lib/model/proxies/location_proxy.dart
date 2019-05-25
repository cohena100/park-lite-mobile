import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationProxy {
  Future<LocationData> get location async {
    try {
      final location = Location();
      return await location.getLocation();
    } on PlatformException catch (_) {
      return null;
    }
  }
}
