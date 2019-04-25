import 'package:pango_lite/model/elements/rate.dart';

class Area {
  static final _idKey = 'id';
  static final _ratesKey = 'rates';
  static final _nameKey = 'name';
  final Map data;

  Area(this.data);

  String get name {
    return data[_nameKey];
  }

  String get id {
    return data[_idKey];
  }

  List<Rate> get rates {
    final List allRates = data[_ratesKey];
    return allRates.map((data) => Rate(data)).toList();
  }
}
