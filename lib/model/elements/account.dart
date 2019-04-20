import 'dart:convert';

class Account {
  static const _userKey = 'user';
  static const _carsKey = 'cars';
  static const _carKey = 'car';
  static const _numberKey = 'number';
  static const _phoneKey = 'phone';
  static const _pangoKey = 'pango';
  static const _nicknameKey = 'nickname';
  Map data;

  Account(String json) {
    data = jsonDecode(json);
  }

  Map get car {
    return cars[0];
  }

  List get cars {
    return data[_userKey][_carsKey];
  }

  String get nickname {
    return cars[0][_nicknameKey];
  }

  String get number {
    return cars[0][_carKey][_numberKey];
  }

  Map get pango {
    return data[_pangoKey];
  }

  String get phone {
    return data[_userKey][_phoneKey];
  }
}
