import 'package:pango_lite/model/elements/parking.dart';

class Cache {
  static final _parkingsKey = 'parkings';
  final Map _data;

  Cache(this._data);

  List<Parking> get parkings {
    List allParkings = _data[_parkingsKey];
    if (allParkings == null) {
      _data[_parkingsKey] = [];
    }
    allParkings = _data[_parkingsKey];
    return allParkings.map((data) => Parking(data)).toList();
  }

  Map<String, dynamic> toJson() {
    return _data;
  }

  void updateParkings(Parking parking) {
    final allParkings = parkings.where((aParking) => !aParking.isTheSame(parking)).toList();
    allParkings.add(parking);
    _data[_parkingsKey] = allParkings.map((parking) => parking.data).toList();
  }
}
