import 'package:location/location.dart';

final areaId1 = '9';
final areaName1 = 'b';
final carId1 = '2';
final carId2 = '4';
final car2 = {
  'car': {
    'number': number2,
    '_id': carId2,
  },
  'nickname': nickname2,
};
final carKey = 'car';
final cityId1 = '8';
final cityName1 = 'a';
final code1 = '3';
final geoPark1 = {
  'cities': [
    {
      'id': cityId1,
      'name': cityName1,
      'areas': [
        {
          'id': areaId1,
          'name': areaName1,
          'rates': [
            {
              'id': rateId1,
              'name': rateName1,
            },
          ],
        }
      ],
    },
  ],
};
final lat1 = 1.0;
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
final lon1 = 2.0;
final nickname1 = 'a';
final nickname2 = 'b';
final number1 = '2';
final number2 = '3';
final parking1 = {
  '_id': parkingId1,
  'cityId': cityId1,
  'cityName': cityName1,
  'areaId': areaId1,
  'areaName': areaName1,
  'rateId': rateId1,
  'rateName': rateName1,
  'lat': lat1.toString(),
  'lon': lon1.toString(),
  'user': userId1,
  'car': carId1,
};
final parkingId1 = '3';
final parkingKey = 'parking';
final phone1 = '1';
final rateId1 = '11';
final rateName1 = 'c';
final token1 = '1';
final Map<String, Object> user1 = {
  '_id': userId1,
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
  ],
};

final userId1 = '1';

final userKey = 'user';
