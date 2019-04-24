import 'package:location/location.dart';

final userKey = 'user';
final parkingKey = 'parking';
final id1 = '1';
final token1 = '1';
final phone1 = '1';
final number1 = '2';
final carId1 = '2';
final parkingId1 = '3';
final nickname1 = 'a';
final code1 = '3';
final company1 = {};
final cityId1 = 5;
final cityName1 = 'b';
final rateId1 = 7;
final rateName1 = 'c';
final lat1 = 1.0;
final lon1 = 2.0;
final user1 = {
  userKey: {
    '_id': id1,
    'phone': phone1,
    'token': token1,
    'cars': [
      {
        'car': {
          'number': number1,
          '_id': carId1,
        },
        'nickname': nickname1
      }
    ]
  },
  'pango': {}
};
final location1 = LocationData.fromMap({
  'latitude': lat1,
  'longitude': lon1,
  'accuracy': 0,
  'altitude': 0,
  'speed': 0,
  'speed_accuracy': 0,
  'heading': 0,
  'time': 0,
});
final areas1 = {
  'pango': {
    'Cities': [
      {
        'CityId': cityId1,
        'CityName': cityName1,
        'GeoZones': [
          {
            'ParkingZones': [
              {'CityId': cityId1, 'id': rateId1, 'name': rateName1},
              {'CityId': cityId1, 'id': 2, 'name': 'b'},
              {'CityId': cityId1, 'id': 3, 'name': 'c'},
            ]
          },
          {
            'ParkingZones': [
              {'CityId': cityId1, 'id': 4, 'name': 'd'},
              {'CityId': cityId1, 'id': 5, 'name': 'e'},
            ]
          },
        ]
      },
      {
        'CityId': 2,
        'CityName': 'b',
        'GeoZones': [
          {
            'ParkingZones': [
              {'CityId': 2, 'id': 6, 'name': 'f'},
              {'CityId': 2, 'id': 7, 'name': 'g'},
              {'CityId': 2, 'id': 8, 'name': 'h'},
            ]
          },
          {
            'ParkingZones': [
              {'CityId': 2, 'id': 9, 'name': 'i'},
              {'CityId': 2, 'id': 10, 'name': 'j'},
            ]
          },
        ]
      },
      {
        'CityId': 3,
        'CityName': 'c',
        'GeoZones': [
          {
            'ParkingZones': [
              {'CityId': 3, 'id': 11, 'name': 'k'},
              {'CityId': 3, 'id': 12, 'name': 'l'},
              {'CityId': 3, 'id': 13, 'name': 'm'},
            ]
          },
          {
            'ParkingZones': [
              {'CityId': 3, 'id': 14, 'name': 'n'},
              {'CityId': 3, 'id': 15, 'name': 'o'},
              {'CityId': 3, 'id': 16, 'name': 'p'},
            ]
          },
        ]
      },
    ]
  }
};
final parking1 = {
  'parking': {
    '_id': parkingId1,
    'cityId': cityId1.toString(),
    'cityName': cityName1,
    'rateId': rateId1.toString(),
    'rateName': rateName1,
    'lat': lat1.toString(),
    'lon': lon1.toString(),
    'user': id1,
    'car': carId1,
  }
};