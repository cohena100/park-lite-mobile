import 'dart:convert';

import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/parking.dart';

class User {
  static final _userKey = 'user';
  static final _idKey = '_id';
  static final _tokenKey = 'token';
  static final _carsKey = 'cars';
  static final _phoneKey = 'phone';
  static final _parkingKey = 'parking';
  final Map _data;

  User(this._data);

  User.fromJson(Map<String, dynamic> json) : _data = json[_userKey];

  List<Car> get cars {
    final List allCars = _data[_carsKey];
    return allCars.map((data) => Car(data)).toList();
  }

  String get id {
    return _data[_idKey];
  }

  Parking get parking {
    final parkingData = _data[_parkingKey];
    return parkingData == null ? null : Parking(parkingData);
  }

  String get phone {
    return _data[_phoneKey];
  }

  String get token {
    return _data[_tokenKey];
  }

  void deleteParking() {
    _data.remove(_parkingKey);
  }

  Car findCar(String carId) {
    return cars.firstWhere((car) => car.id == carId, orElse: () => null);
  }

  String toJson() {
    return jsonEncode(_data);
  }

  void updateParking(Parking parking) {
    _data[_parkingKey] = parking.data;
  }
}
