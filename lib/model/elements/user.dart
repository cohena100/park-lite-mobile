import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/parking.dart';
import 'package:pango_lite/model/elements/payment.dart';

class User {
  static final _userKey = 'user';
  static final _idKey = '_id';
  static final _tokenKey = 'token';
  static final _carsKey = 'cars';
  static final _phoneKey = 'phone';
  static final _parkingKey = 'parking';
  static final _paymentKey = 'payment';
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
    final data = _data[_parkingKey];
    return data == null ? null : Parking(data);
  }

  Car get parkingCar {
    final innerCarId = parking.carId;
    return findInnerCar(innerCarId);
  }

  Payment get payment {
    final data = _data[_paymentKey];
    return data == null ? null : Payment(data);
  }

  String get phone {
    return _data[_phoneKey];
  }

  String get token {
    return _data[_tokenKey];
  }

  void addCar(Car car) {
    final allCars = cars;
    allCars.add(car);
    _data[_carsKey] = allCars.map((car) => car.data).toList();
  }

  void deleteParking() {
    _data.remove(_parkingKey);
  }

  void deletePayment() {
    _data.remove(_paymentKey);
  }

  void deleteToken() {
    _data.remove(_tokenKey);
  }

  Car findCar(String carId) {
    return cars.firstWhere((car) => car.id == carId, orElse: () => null);
  }

  Car findInnerCar(String innerId) {
    return cars.firstWhere((car) => car.innerId == innerId, orElse: () => null);
  }

  void removeCar(Car car) {
    final allCars = cars;
    final withoutCar = allCars.where((c) => c.id != car.id).toList();
    _data[_carsKey] = withoutCar.map((car) => car.data).toList();
  }

  Map<String, dynamic> toJson() {
    return _data;
  }

  void updateParking(Parking parking) {
    _data[_parkingKey] = parking.data;
  }

  void updatePayment(Payment payment) {
    _data[_paymentKey] = payment.data;
  }
}
