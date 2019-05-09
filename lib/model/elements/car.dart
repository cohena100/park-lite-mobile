class Car {
  static final _idKey = '_id';
  static final _carKey = 'car';
  static final _numberKey = 'number';
  static final _nicknameKey = 'nickname';
  final Map data;

  Car(this.data);

  Car.fromJson(Map<String, dynamic> json) : data = json[_carKey];

  String get id {
    return data[_idKey];
  }

  String get innerId {
    return data[_carKey][_idKey];
  }

  String get nickname {
    return data[_nicknameKey];
  }

  String get number {
    return data[_carKey][_numberKey];
  }

  Map<String, dynamic> toJson() {
    return data;
  }
}
