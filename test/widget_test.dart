// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pango_lite/main.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/bluetooth_proxy.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/model/proxies/notification_proxy.dart';
import 'package:pango_lite/pages/widget_keys.dart';
import 'package:pango_lite/playground/defs.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  final bluetoothProxyStream = BehaviorSubject<bool>();

  tearDownAll(() {
    bluetoothProxyStream.close();
  });

  setUp(() {
    model = Model(
      MockNetworkProxy(),
      LocalDBProxy(inMemory: true),
      MockLocationProxy(),
      MockBluetoothProxy(),
      MockNotificationProxy(),
    );
    when(model.bluetoothProxy.stream)
        .thenAnswer((_) => bluetoothProxyStream.stream);
    when(model.notificationProxy.showNotification(any, any)).thenAnswer((_) {
      return;
    });
    model.localDBProxy.inMemoryUser = null;
    user1 = {
      '_id': userId1,
      'phone': phone1,
      'token': token1,
      'cars': [],
    };
  });

  group('login', () {
    testWidgets('Login success', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.phonePageKey), findsOneWidget);
      when(model.networkProxy.sendLogin(phone1)).thenAnswer((_) async => {
            NetworkProxyKeys.code: 401,
            NetworkProxyKeys.body: jsonEncode({validateKey: validate1}),
          });
      await tester.enterText(find.byKey(WidgetKeys.phoneTextFieldKey), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.validatePageKey), findsOneWidget);
      when(model.networkProxy.sendLoginValidate(userId1, validateId1, code1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode({userKey: user1}),
              });
      await tester.enterText(
          find.byKey(WidgetKeys.validateTextFieldKey), code1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
    });

    testWidgets('Not logged in', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.phonePageKey), findsOneWidget);
    });

    testWidgets('Not logged in because not token', (WidgetTester tester) async {
      user1.remove('token');
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.phonePageKey), findsOneWidget);
    });

    testWidgets('Already logged in', (WidgetTester tester) async {
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
    });

    testWidgets('Login failed', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.phonePageKey), findsOneWidget);
      when(model.networkProxy.sendLogin(phone1)).thenAnswer((_) async => {
            NetworkProxyKeys.code: 400,
            NetworkProxyKeys.body: null,
          });
      await tester.enterText(find.byKey(WidgetKeys.phoneTextFieldKey), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.phonePageKey), findsOneWidget);
      when(model.networkProxy.sendLogin(phone1)).thenAnswer((_) async => {
            NetworkProxyKeys.code: 401,
            NetworkProxyKeys.body: jsonEncode({validateKey: validate1}),
          });
      await tester.enterText(find.byKey(WidgetKeys.phoneTextFieldKey), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.validatePageKey), findsOneWidget);
      when(model.networkProxy.sendLoginValidate(userId1, validateId1, code1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 400,
                NetworkProxyKeys.body: null,
              });
      await tester.enterText(
          find.byKey(WidgetKeys.validateTextFieldKey), code1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.validatePageKey), findsOneWidget);
    });

    testWidgets('Push and pop between pages', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.phonePageKey), findsOneWidget);
      when(model.networkProxy.sendLogin(phone1)).thenAnswer((_) async => {
            NetworkProxyKeys.code: 401,
            NetworkProxyKeys.body: jsonEncode({validateKey: validate1}),
          });
      await tester.enterText(find.byKey(WidgetKeys.phoneTextFieldKey), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.validatePageKey), findsOneWidget);
      await tester.enterText(
          find.byKey(WidgetKeys.validateTextFieldKey), code1);
      final NavigatorState navigator =
          tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.phonePageKey), findsOneWidget);
      TextField textField = find
          .byKey(WidgetKeys.phoneTextFieldKey)
          .evaluate()
          .toList()
          .first
          .widget;
      expect(textField.controller.value.text, phone1);
      await tester.enterText(find.byKey(WidgetKeys.phoneTextFieldKey), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.validatePageKey), findsOneWidget);
      textField = find
          .byKey(WidgetKeys.validateTextFieldKey)
          .evaluate()
          .toList()
          .first
          .widget;
      expect(textField.controller.value.text, code1);
    });

    testWidgets('Exit', (WidgetTester tester) async {
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.userTabKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.userPageKey), findsOneWidget);
      when(model.networkProxy.sendLogout(userId1, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: null,
              });
      expect(find.byKey(WidgetKeys.exitKey), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.exitKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.phonePageKey), findsOneWidget);
    });

    testWidgets('Exit still event after 400', (WidgetTester tester) async {
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.userTabKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.userPageKey), findsOneWidget);
      when(model.networkProxy.sendLogout(userId1, token1))
          .thenAnswer((_) async => {
        NetworkProxyKeys.code: 400,
        NetworkProxyKeys.body: null,
      });
      await tester.tap(find.byKey(WidgetKeys.exitKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.phonePageKey), findsOneWidget);
    });
  });

  group('car', () {
    testWidgets('Add first car after login', (WidgetTester tester) async {
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.startKey), findsNothing);
      expect(find.byKey(WidgetKeys.addKey), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.addKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.carPageKey), findsOneWidget);
      await tester.enterText(find.byKey(WidgetKeys.carTextFieldKey), number1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.nicknamePageKey), findsOneWidget);
      when(model.networkProxy.sendAdd(userId1, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 401,
                NetworkProxyKeys.body: jsonEncode({validateKey: validateCar1}),
              });
      await tester.enterText(
          find.byKey(WidgetKeys.nicknameTextFieldKey), nickname1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.validatePageKey), findsOneWidget);
      when(model.networkProxy.sendAddValidate(
              userId1, number1, nickname1, validateId1, code1, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode({carKey: car1}),
              });
      await tester.enterText(
          find.byKey(WidgetKeys.validateTextFieldKey), code1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.startKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.addKey), findsNothing);
    });

    testWidgets('add car success', (WidgetTester tester) async {
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.userTabKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.userPageKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.addKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.removeKey), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.addKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.carPageKey), findsOneWidget);
      await tester.enterText(find.byKey(WidgetKeys.carTextFieldKey), number1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.nicknamePageKey), findsOneWidget);
      when(model.networkProxy.sendAdd(userId1, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 401,
                NetworkProxyKeys.body: jsonEncode({validateKey: validateCar1}),
              });
      await tester.enterText(
          find.byKey(WidgetKeys.nicknameTextFieldKey), nickname1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.validatePageKey), findsOneWidget);
      when(model.networkProxy.sendAddValidate(
              userId1, number1, nickname1, validateId1, code1, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode({carKey: car1}),
              });
      await tester.enterText(
          find.byKey(WidgetKeys.validateTextFieldKey), code1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.userPageKey), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.parkTabKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.startKey), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.startKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.selectCarPageKey), findsOneWidget);
      expect(find.byKey(Key(carId1)), findsOneWidget);
    });

    testWidgets('remove car success', (WidgetTester tester) async {
      user1[carsKey] = [car1];
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WidgetKeys.userTabKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WidgetKeys.removeKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.selectCarPageKey), findsOneWidget);
      expect(find.byKey(Key(carId1)), findsOneWidget);
      when(model.networkProxy.sendRemove(userId1, carId1, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode({carKey: car1}),
              });
      await tester.tap(find.byKey(Key(carId1)));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.startKey), findsNothing);
      expect(find.byKey(WidgetKeys.addKey), findsOneWidget);
    });
  });

  group('park', () {
    testWidgets('start parking success', (WidgetTester tester) async {
      user1[carsKey] = [car1];
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.startKey), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.startKey));
      await tester.pumpAndSettle();
      when(model.locationProxy.currentLocation)
          .thenAnswer((_) async => location1);
      model.localDBProxy.geoPark = geoPark1;
      expect(find.byKey(WidgetKeys.selectCarPageKey), findsOneWidget);
      await tester.tap(find.byKey(Key(carId1)));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.selectCityPageKey), findsOneWidget);
      await tester.tap(find.byKey(Key(cityId1)));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.selectAreaPageKey), findsOneWidget);
      await tester.tap(find.byKey(Key(areaId1)));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.selectRatePageKey), findsOneWidget);
      when(model.networkProxy.sendStart(
              userId1,
              carId1,
              lat1.toString(),
              lon1.toString(),
              cityId1,
              cityName1,
              areaId1,
              areaName1,
              rateId1,
              rateName1,
              token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode({parkingKey: parking1}),
              });
      await tester.tap(find.byKey(Key(rateId1)));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.stopKey), findsOneWidget);
    });

    testWidgets('stop parking success', (WidgetTester tester) async {
      user1[carsKey] = [car1];
      user1[parkingKey] = parking1;
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
      when(model.networkProxy.sendStop(userId1, parkingId1, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode({parkingKey: parking1}),
              });
      await tester.tap(find.byKey(WidgetKeys.stopKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.startKey), findsOneWidget);
    });
  });
}

class MockLocationProxy extends Mock implements LocationProxy {}

class MockNetworkProxy extends Mock implements NetworkProxy {}

class MockBluetoothProxy extends Mock implements BluetoothProxy {}

class MockNotificationProxy extends Mock implements NotificationProxy {}
