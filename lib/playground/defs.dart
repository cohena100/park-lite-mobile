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
  ],
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

final parking1 = {
  '_id': parkingId1,
  'cityId': cityId1.toString(),
  'cityName': cityName1,
  'rateId': rateId1.toString(),
  'rateName': rateName1,
  'lat': lat1.toString(),
  'lon': lon1.toString(),
  'user': id1,
  'car': carId1,
};
