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
  Map _data;

  User(this._data);

  List<Car> get cars {
    final List allCars = _data[_userKey][_carsKey];
    return allCars.map((data) => Car(data)).toList();
  }

  String get id {
    return _innerUser[_idKey];
  }

  Parking get parking {
    final parkingData = _innerUser[_parkingKey];
    return parkingData == null ? null : Parking(parkingData);
  }

  String get phone {
    return _innerUser[_phoneKey];
  }

  String get token {
    return _innerUser[_tokenKey];
  }

  Map get _innerUser {
    return _data[_userKey];
  }

  void deleteParking() {
    _innerUser.remove(_parkingKey);
  }

  Car findCar(String carId) {
    return cars.firstWhere((car) => car.id == carId, orElse: () => null);
  }

  String toJson() {
    return jsonEncode(_data);
  }

  void updateParking(Parking parking) {
    _innerUser[_parkingKey] = parking.data;
  }
}
