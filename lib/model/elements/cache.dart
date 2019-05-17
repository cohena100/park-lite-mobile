class Cache {

  static final _parkingsKey = 'parkings';
  final Map _data;

  Cache(this._data);

  Cache.fromJson(Map<String, dynamic> json) : _data = json[_parkingsKey];

  Map<String, dynamic> toJson() {
    return _data;
  }
}
