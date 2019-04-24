class Rate {
  static final _nameKey = 'name';
  static final _idKey = 'id';
  static final _cityIdKey = 'CityId';
  final Map data;

  Rate(this.data);

  int get cityId {
    return data[_cityIdKey];
  }

  int get id {
    return data[_idKey];
  }

  String get name {
    return data[_nameKey];
  }
}
