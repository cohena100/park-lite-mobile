class Parking {
  static final _parkingKey = 'parking';
  static final _idKey = '_id';
  static final _carIdKey = 'car';
  static final _latKey = 'lat';
  static final _lonKey = 'lon';
  static final _cityIdKey = 'cityId';
  static final _areaIdKey = 'areaId';
  static final _rateIdKey = 'rateId';
  static final _cityName = 'cityName';
  static final _areaName = 'areaName';
  static final _rateName = 'rateName';
  Map data;

  Parking(this.data);

  Parking.fromJson(Map<String, dynamic> json) : data = json[_parkingKey];

  String get areaId {
    return data[_areaIdKey];
  }

  String get areaName {
    return data[_areaName];
  }

  String get carId {
    return data[_carIdKey];
  }

  String get cityId {
    return data[_cityIdKey];
  }

  String get cityName {
    return data[_cityName];
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

  String get rateName {
    return data[_rateName];
  }

  bool isTheSame(Parking other) {
    return (this.carId == other.carId &&
        this.cityId == other.cityId &&
        this.areaId == other.areaId &&
        this.rateId == other.rateId);
  }
}
