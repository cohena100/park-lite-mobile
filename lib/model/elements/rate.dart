class Rate {
  static final _nameKey = 'name';
  static final _idKey = 'id';
  final Map data;

  Rate(this.data);

  String get id {
    return data[_idKey];
  }

  String get name {
    return data[_nameKey];
  }
}
