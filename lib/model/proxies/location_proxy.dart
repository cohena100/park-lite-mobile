import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationProxy {
  Future<LocationData> get currentLocation async {
    try {
      var location = Location();
      return await location.getLocation();
    } on PlatformException catch (_) {}
    return LocationData.fromMap({
      'latitude': 0,
      'longitude': 0,
      'accuracy': 0,
      'altitude': 0,
      'speed': 0,
      'speed_accuracy': 0,
      'heading': 0,
      'time': 0,
    });
  }
}
