import 'package:pango_lite/model/elements/rate.dart';
import 'package:pango_lite/model/elements/geo_zone.dart';

class City {
  static final _nameKey = 'CityName';
  static final _idKey = 'CityId';
  static final _geoZones = 'GeoZones';
  final Map data;

  City(this.data);

  int get id {
    return data[_idKey];
  }

  String get name {
    return data[_nameKey];
  }

  List<Rate> get rates {
    return _allGeoZones
        .map((geoZone) => geoZone.rates)
        .expand((rates) => rates)
        .toList();
  }

  List<GeoZone> get _allGeoZones {
    final List allGeoZones = data[_geoZones];
    return allGeoZones.map((geoZone) => GeoZone(geoZone)).toList();
  }
}
