class Car {
  static const _carKey = 'car';
  static const _numberKey = 'number';
  static const _nicknameKey = 'nickname';
  final Map data;

  Car(this.data);

  String get nickname {
    return data[_nicknameKey];
  }

  String get number {
    return data[_carKey][_numberKey];
  }
}
