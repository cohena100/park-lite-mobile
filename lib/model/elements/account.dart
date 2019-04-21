import 'package:pango_lite/model/elements/car.dart';

class Account {
  static final _userKey = 'user';
  static final _carsKey = 'cars';
  static final _phoneKey = 'phone';
  static final _companyKey = 'pango';
  Map data;

  Account(this.data);

  List<Car> get cars {
    List allCars = data[_userKey][_carsKey];
    return allCars.map((data) => Car(data)).toList();
  }

  Map get company {
    return data[_companyKey];
  }

  String get phone {
    return data[_userKey][_phoneKey];
  }
}
