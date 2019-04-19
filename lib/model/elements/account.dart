import 'dart:convert';

class Account {
  Map data;
  static const car = 'car';
  static const number = 'number';

  Account(String json) {
    data = jsonDecode(json);
  }

  List get cars {
    return data['user']['cars'];
  }

  List get carNumbers {
    return cars.map((car) {
      return car[Account.car][Account.number];
    }).toList();
  }
}
