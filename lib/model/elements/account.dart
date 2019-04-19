import 'dart:convert';

class Account {
  static const car = 'car';
  static const number = 'number';
  static const nickname = 'nickname';
  Map data;

  Account(String json) {
    data = jsonDecode(json);
  }

  List get cars {
    return data['user']['cars'];
  }
}
