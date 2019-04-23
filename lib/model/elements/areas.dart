import 'package:pango_lite/model/elements/city.dart';

class Areas {
  static final _companyKey = 'pango';
  static final _citiesKey = 'Cities';
  Map data;

  Areas(this.data);

  List<City> get cities {
    final List allCities = data[_companyKey][_citiesKey];
    return allCities.map((city) => City(city)).toList();
  }
}
