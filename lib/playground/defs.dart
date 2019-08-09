import 'package:location/location.dart';

final areaId1 = '9';
final areaId11 = '90';
final areaId2 = '90';
final areaId3 = '900';
final areaName1 = 'b';
final areaName11 = 'bb';
final areaName2 = 'c';
final areaName3 = 'd';
final bl = [32.08258, 34.85486];
final bm = [32.08258, 34.85631];
final br = [32.08258, 34.85775];
final cache1 = {
  'parkings': [
    parking1,
  ]
};
final car1 = {
  '_id': carId1,
  'car': {
    'number': number1,
    '_id': innerCarId1,
  },
  'nickname': nickname1,
};
final car2 = {
  '_id': carId2,
  'car': {
    'number': number2,
    '_id': innerCarId2,
  },
  'nickname': nickname2,
};
final carId1 = '30';
final carId2 = '40';
final carKey = 'car';
final carsKey = 'cars';
final cityId1 = '8';
final cityId2 = '80';
final cityId3 = '800';
final cityName1 = 'a';

final cityName2 = 'b';
final cityName3 = 'c';
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
              'price': price1,
            },
            {
              'id': rateId2,
              'name': rateName2,
              'price': price3,
            },
          ],
          'polygon': [
            mm,
            tm,
            tr,
            mr,
          ],
        },
        {
          'id': areaId11,
          'name': areaName11,
          'rates': [
            {
              'id': rateId1,
              'name': rateName1,
              'price': price2,
            },
          ],
          'polygon': [
            bm,
            mm,
            mr,
            br,
          ],
        },
      ],
      'polygon': [
        bm,
        mm,
        tm,
        tr,
        mr,
        br,
      ],
    },
    {
      'id': cityId2,
      'name': cityName2,
      'areas': [
        {
          'id': areaId2,
          'name': areaName2,
          'rates': [
            {
              'id': rateId2,
              'name': rateName2,
              'price': price2,
            },
          ],
          'polygon': [
            bl,
            tl,
            tm,
            mm,
            bm,
          ],
        }
      ],
      'polygon': [
        bl,
        tl,
        tm,
        mm,
        bm,
      ],
    },
  ],
};
final innerCarId1 = '2';
final innerCarId2 = '3';
final lat1 = 32.08373;
final lat2 = 32.083731;
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
final location2 = LocationData.fromMap({
  'latitude': lat2,
  'longitude': lon2,
  'accuracy': 0,
  'altitude': 0,
  'speed': 0,
  'speed_accuracy': 0,
  'heading': 0,
  'time': 0,
});
final lon1 = 34.85641;
final lon2 = 34.856411;
final mm = [32.08373, 34.85641];
final mr = [32.08381, 34.85805];
final nickname1 = 'a';
final nickname2 = 'aa';
final number1 = '3';
final number2 = '4';
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
  'car': innerCarId1,
};
final parking2 = {
  '_id': parkingId2,
  'cityId': cityId2,
  'cityName': cityName2,
  'areaId': areaId2,
  'areaName': areaName2,
  'rateId': rateId2,
  'rateName': rateName2,
  'lat': lat1.toString(),
  'lon': lon1.toString(),
  'user': userId1,
  'car': innerCarId2,
};
final parking3 = {
  '_id': parkingId3,
  'cityId': cityId3,
  'cityName': cityName3,
  'areaId': areaId3,
  'areaName': areaName3,
  'rateId': rateId2,
  'rateName': rateName2,
  'lat': lat1.toString(),
  'lon': lon1.toString(),
  'user': userId1,
  'car': innerCarId2,
};
final parking4 = {
  '_id': parkingId4,
  'cityId': cityId3,
  'cityName': cityName3,
  'areaId': areaId3,
  'areaName': areaName3,
  'rateId': rateId1,
  'rateName': rateName1,
  'lat': lat1.toString(),
  'lon': lon1.toString(),
  'user': userId1,
  'car': innerCarId2,
};
final parking5 = {
  '_id': parkingId5,
  'cityId': cityId2,
  'cityName': cityName2,
  'areaId': areaId3,
  'areaName': areaName3,
  'rateId': rateId2,
  'rateName': rateName2,
  'lat': lat1.toString(),
  'lon': lon1.toString(),
  'user': userId1,
  'car': innerCarId2,
};
final parkingId1 = '1';
final parkingId2 = '2';
final parkingId3 = '3';
final parkingId4 = '4';
final parkingId5 = '5';
final parkingKey = 'parking';
final payment1 = {
  'amount': 20,
  'sessionId': '1',
  'parking': parking1,
};
final paymentKey = 'payment';
final phone1 = '4';
final price1 = '100';
final price2 = '200';
final price3 = '500';
final rateId1 = '1';
final rateId2 = '2';
final rateName1 = 'a';
final rateName2 = 'b';
final tl = [32.08489, 34.85542];
final tm = [32.08487, 34.85641];
final token1 = '1';
final tokenKey = 'token';
final tr = [32.08504, 34.85801];
Map<String, Object> user1;
final userId1 = '5';
final userKey = 'user';
final validate1 = {
  'userId': userId1,
  'validateId': validateId1,
  'code': code1,
};
final validateCar1 = {
  'validateId': validateId1,
  'code': code1,
};
final validateId1 = '2';
final validateKey = 'validate';
