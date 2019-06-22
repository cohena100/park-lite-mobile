import 'package:pango_lite/model/elements/area.dart';

import 'polygon.dart';

class City {
  static final _idKey = 'id';
  static final _nameKey = 'name';
  static final _areasKey = 'areas';
  static final _polygonKey = 'polygon';
  final Map data;

  City(this.data);

  List<Area> get areas {
    final List allAreas = data[_areasKey];
    return allAreas.map((data) => Area(data)).toList();
  }

  String get id {
    return data[_idKey];
  }

  String get name {
    return data[_nameKey];
  }

  Polygon get polygon {
    return Polygon(data[_polygonKey]);
  }
}
