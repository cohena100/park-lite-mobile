import 'package:pango_lite/model/elements/city.dart';

class GeoPark {
  static final _citiesKey = 'cities';
  final Map data = {
    'cities': [
      {
        'id': '1',
        'name': 'פתח תקווה',
        'areas': [
          {
            'id': '2',
            'name': 'מערב',
            'rates': [
              {
                'id': '3',
                'name': 'שעתי',
              },
              {
                'id': '4',
                'name': 'יומי',
              },
              {
                'id': '5',
                'name': 'חודשי',
              },
            ],
          },
          {
            'id': '6',
            'name': 'מזרח',
            'rates': [
              {
                'id': '7',
                'name': 'שעתי',
              },
            ],
          },
        ],
      },
      {
        'id': '8',
        'name': 'גבעת שמואל',
        'areas': [
          {
            'id': '9',
            'name': 'כל העיר',
            'rates': [
              {
                'id': '10',
                'name': 'שעתי',
              },
              {
                'id': '11',
                'name': 'יומי',
              },
            ],
          },
        ],
      },
    ],
  };

  List<City> get cities {
    final List allCities = data[_citiesKey];
    return allCities.map((data) => City(data)).toList();
  }
}
