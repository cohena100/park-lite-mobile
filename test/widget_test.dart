// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';
import 'package:pango_lite/main.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class MockNetworkProxy extends Mock implements NetworkProxy {}

class MockLocalDBProxy extends Mock implements LocalDBProxy {}

class MockLocationProxy extends Mock implements LocationProxy {}

void main() {
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

  group('login', () {
    testWidgets('Login success', (WidgetTester tester) async {
      model =
          Model(MockNetworkProxy(), MockLocalDBProxy(), MockLocationProxy());
      when(model.localDBProxy.loadUser()).thenAnswer((_) async => null);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      when(model.localDBProxy.loadUser()).thenAnswer((_) async => user1);
      await tester.enterText(find.byKey(Key('PhoneTextField')), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('CarPage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('CarTextField')), number1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('NicknamePage')), findsOneWidget);
      when(model.networkProxy.sendLogin(phone1, number1, nickname1)).thenAnswer(
          (_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode(user1)
              });
      await tester.enterText(find.byKey(Key('NicknameTextField')), nickname1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
    });

    testWidgets('Not logged in', (WidgetTester tester) async {
      model =
          Model(MockNetworkProxy(), MockLocalDBProxy(), MockLocationProxy());
      when(model.localDBProxy.loadUser()).thenAnswer((_) async => null);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(Key('PhonePage')), findsOneWidget);
    });

    testWidgets('Already logged in', (WidgetTester tester) async {
      model =
          Model(MockNetworkProxy(), MockLocalDBProxy(), MockLocationProxy());
      when(model.localDBProxy.loadUser()).thenAnswer((_) async => user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
    });

    testWidgets('Login failed', (WidgetTester tester) async {
      model =
          Model(MockNetworkProxy(), MockLocalDBProxy(), MockLocationProxy());
      when(model.localDBProxy.loadUser()).thenAnswer((_) async => null);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('PhoneTextField')), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('CarPage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('CarTextField')), number1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      when(model.networkProxy.sendLogin(phone1, number1, nickname1)).thenAnswer(
          (_) async =>
              {NetworkProxyKeys.code: 400, NetworkProxyKeys.body: null});
      expect(find.byKey(Key('NicknamePage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('NicknameTextField')), nickname1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.byKey(Key('NicknamePage')), findsOneWidget);
    });

    testWidgets('Pop and push between pages', (WidgetTester tester) async {
      model =
          Model(MockNetworkProxy(), MockLocalDBProxy(), MockLocationProxy());
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('PhoneTextField')), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('CarTextField')), number1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('NicknameTextField')), nickname1);
      final NavigatorState navigator =
          tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();
      TextField textField =
          find.byKey(Key('PhoneTextField')).evaluate().toList().first.widget;
      expect(textField.controller.value.text, phone1);
      await tester.enterText(find.byKey(Key('PhoneTextField')), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      textField =
          find.byKey(Key('CarTextField')).evaluate().toList().first.widget;
      expect(textField.controller.value.text, number1);
      await tester.enterText(find.byKey(Key('CarTextField')), number1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      textField =
          find.byKey(Key('NicknameTextField')).evaluate().toList().first.widget;
      expect(textField.controller.value.text, nickname1);
    });

    testWidgets('Validate success', (WidgetTester tester) async {
      model =
          Model(MockNetworkProxy(), MockLocalDBProxy(), MockLocationProxy());
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      when(model.localDBProxy.loadUser()).thenAnswer((_) async => user1);
      await tester.enterText(find.byKey(Key('PhoneTextField')), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('CarPage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('CarTextField')), number1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      when(model.networkProxy.sendLogin(phone1, number1, nickname1)).thenAnswer(
          (_) async =>
              {NetworkProxyKeys.code: 401, NetworkProxyKeys.body: null});
      expect(find.byKey(Key('NicknamePage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('NicknameTextField')), nickname1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      when(model.networkProxy.sendValidate(phone1, number1, code1)).thenAnswer(
          (_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode(user1)
              });
      expect(find.byKey(Key('ValidatePage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('ValidateTextField')), code1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
    });
  });

  group('park', () {
    testWidgets('reaching rates', (WidgetTester tester) async {
      model =
          Model(MockNetworkProxy(), MockLocalDBProxy(), MockLocationProxy());
      when(model.localDBProxy.loadUser()).thenAnswer((_) async => user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
      await tester.tap(find.byKey(Key('Start')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('SelectCarPage')), findsOneWidget);
      when(model.locationProxy.currentLocation)
          .thenAnswer((_) async => location1);
      when(model.networkProxy.sendAreas(id1, location1.latitude.toString(),
              location1.longitude.toString(), company1, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode(areas1)
              });
      await tester.tap(find.byKey(Key(number1)));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('SelectCityPage')), findsOneWidget);
      await tester.tap(find.byKey(Key('3')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('SelectRatePage')), findsOneWidget);
      expect(find.byKey(Key('11')), findsOneWidget);
      expect(find.byKey(Key('13')), findsOneWidget);
      expect(find.byKey(Key('14')), findsOneWidget);
      expect(find.byKey(Key('16')), findsOneWidget);
      expect(find.byKey(Key('1')), findsNothing);
      expect(find.byKey(Key('10')), findsNothing);
    });

    testWidgets('start parking success', (WidgetTester tester) async {
      model =
          Model(MockNetworkProxy(), MockLocalDBProxy(), MockLocationProxy());
      when(model.localDBProxy.loadUser()).thenAnswer((_) async => user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('Start')));
      await tester.pumpAndSettle();
      when(model.locationProxy.currentLocation)
          .thenAnswer((_) async => location1);
      when(model.networkProxy.sendAreas(id1, location1.latitude.toString(),
              location1.longitude.toString(), company1, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode(areas1),
              });
      when(model.networkProxy.sendStart(
              id1,
              carId1,
              lat1.toString(),
              lon1.toString(),
              cityId1.toString(),
              cityName1,
              rateId1.toString(),
              rateName1,
              number1,
              company1,
              token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode(parking1),
              });
      await tester.tap(find.byKey(Key(number1)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(cityId1.toString())));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(rateId1.toString())));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
      expect(find.byKey(Key('Stop')), findsOneWidget);
    });

    testWidgets('stop parking success', (WidgetTester tester) async {
      model =
          Model(MockNetworkProxy(), MockLocalDBProxy(), MockLocationProxy());
      user1[userKey][parkingKey] = parking1[parkingKey];
      when(model.localDBProxy.loadUser()).thenAnswer((_) async => user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      when(model.networkProxy.sendStop(
              id1,
              carId1,
              parkingId1,
              lat1.toString(),
              lon1.toString(),
              cityId1.toString(),
              rateId1.toString(),
              number1,
              company1,
              token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode(parking1),
              });
      await tester.tap(find.byKey(Key('Stop')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
      expect(find.byKey(Key('Start')), findsOneWidget);
    });
  });
}
