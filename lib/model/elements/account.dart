import 'package:pango_lite/model/elements/car.dart';

class Account {
  static const _userKey = 'user';
  static const _carsKey = 'cars';
  static const _phoneKey = 'phone';
  static const _companyKey = 'pango';
  Map data;

  Account(this.data);

  List<Car> get cars {
    List allCars = data[_userKey][_carsKey];
    return allCars.map((data) => Car(data)).toList();
  }

  Map get company {
    return data[_companyKey];
  }

  Car get loginCar {
    final allCars = cars;
    return allCars.length > 0 ? cars[0] : null;
  }

  String get phone {
    return data[_userKey][_phoneKey];
  }
}
