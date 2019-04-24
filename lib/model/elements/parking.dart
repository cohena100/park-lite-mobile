class Parking {
  static final _parkingKey = 'parking';
  static final _idKey = '_id';
  static final _carIdKey = 'car';
  static final _latKey = 'lat';
  static final _lonKey = 'lon';
  static final _cityIdKey = 'cityId';
  static final _rateIdKey = 'rateId';
  Map data;

  Parking(this.data);

  Parking.fromJson(Map<String, dynamic> json) : data = json[_parkingKey];

  String get carId {
    return data[_carIdKey];
  }

  String get cityId {
    return data[_cityIdKey];
  }

  String get id {
    return data[_idKey];
  }

  String get lat {
    return data[_latKey];
  }

  String get lon {
    return data[_lonKey];
  }

  String get rateId {
    return data[_rateIdKey];
  }
}
