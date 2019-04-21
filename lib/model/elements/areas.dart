import 'package:pango_lite/model/elements/city.dart';

class Areas {
  static final _areasKey = 'areas';
  static final _citiesKey = 'Cities';
  Map data;

  Areas(this.data);

  List<City> get cities {
    final List allCities = data[_areasKey][_citiesKey];
    return allCities.map((city) => City(city)).toList();
  }
}
