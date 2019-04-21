class City {
  static final _nameKey = 'CityName';
  static final _idKey = 'CityId';
  final Map data;

  City(this.data);

  String get name {
    return data[_nameKey];
  }

  int get id {
    return data[_idKey];
  }
}
