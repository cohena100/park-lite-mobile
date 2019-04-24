import 'dart:convert';

import 'package:pango_lite/model/elements/car.dart';

class User {
  static final _userKey = 'user';
  static final _idKey = '_id';
  static final _tokenKey = 'token';
  static final _carsKey = 'cars';
  static final _phoneKey = 'phone';
  static final _companyKey = 'pango';
  static final _parkingKey = 'parking';
  Map data;

  User(this.data);

  List<Car> get cars {
    List allCars = data[_userKey][_carsKey];
    return allCars.map((data) => Car(data)).toList();
  }

  Map get company {
    return data[_companyKey];
  }

  String get id {
    return _innerUser[_idKey];
  }

  Map get parking {
    return _innerUser[_parkingKey];
  }

  String get phone {
    return _innerUser[_phoneKey];
  }

  String get token {
    return _innerUser[_tokenKey];
  }

  Map get _innerUser {
    return data[_userKey];
  }

  String toJson() {
    return jsonEncode(_innerUser);
  }

  void updateParking(Map parking) {
    _innerUser[_parkingKey] = parking[_parkingKey];
  }
}
