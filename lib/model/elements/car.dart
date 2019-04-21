class Car {
  static final _carKey = 'car';
  static final _numberKey = 'number';
  static final _nicknameKey = 'nickname';
  final Map data;

  Car(this.data);

  String get nickname {
    return data[_nicknameKey];
  }

  String get number {
    return data[_carKey][_numberKey];
  }
}
