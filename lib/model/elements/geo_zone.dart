import 'package:pango_lite/model/elements/rate.dart';

class GeoZone {
  static final _rates = 'ParkingZones';
  final Map data;

  GeoZone(this.data);

  List<Rate> get rates {
    List allRates = data[_rates];
    return allRates.map((rate) => Rate(rate)).toList();
  }
}
