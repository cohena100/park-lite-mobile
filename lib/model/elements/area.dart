import 'package:pango_lite/model/elements/rate.dart';

import 'Polygon.dart';

class Area {
  static final _idKey = 'id';
  static final _ratesKey = 'rates';
  static final _nameKey = 'name';
  final Map data;
  static final _polygonKey = 'polygon';

  Area(this.data);

  String get id {
    return data[_idKey];
  }

  String get name {
    return data[_nameKey];
  }

  List<Rate> get rates {
    final List allRates = data[_ratesKey];
    return allRates.map((data) => Rate(data)).toList();
  }

  Polygon get polygon {
    return Polygon(data[_polygonKey]);
  }
}
