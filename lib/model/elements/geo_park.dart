import 'package:pango_lite/model/elements/city.dart';

class GeoPark {
  static final _citiesKey = 'cities';
  final Map data;

  GeoPark(this.data);

  List<City> get cities {
    final List allCities = data[_citiesKey];
    return allCities.map((data) => City(data)).toList();
  }
}
