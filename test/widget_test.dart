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
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/pages/widget_keys.dart';
import 'package:pango_lite/playground/defs.dart';

void main() {
  setUp(() {
    model = Model(
        MockNetworkProxy(), LocalDBProxy(inMemory: true), MockLocationProxy());
    model.localDBProxy.inMemoryUser = null;
    user1 = {
      '_id': userId1,
      'phone': phone1,
      'token': token1,
      'cars': [
        car1,
      ],
    };
  });

  group('login', () {
    testWidgets('Login success', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(WidgetKeys.phoneTextFieldKey), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.carPageKey), findsOneWidget);
      await tester.enterText(find.byKey(WidgetKeys.carTextFieldKey), number1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.nicknamePageKey), findsOneWidget);
      when(model.networkProxy.sendLogin(phone1, number1, nickname1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode({userKey: user1}),
              });
      await tester.enterText(find.byKey(WidgetKeys.nicknameTextFieldKey), nickname1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
    });

    testWidgets('Not logged in', (WidgetTester tester) async {
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
      await tester.enterText(find.byKey(WidgetKeys.phoneTextFieldKey), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.carPageKey), findsOneWidget);
      await tester.enterText(find.byKey(WidgetKeys.carTextFieldKey), number1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.nicknamePageKey), findsOneWidget);
      when(model.networkProxy.sendLogin(phone1, number1, nickname1)).thenAnswer(
          (_) async =>
              {NetworkProxyKeys.code: 400, NetworkProxyKeys.body: null});
      await tester.enterText(find.byKey(WidgetKeys.nicknameTextFieldKey), nickname1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.byKey(WidgetKeys.nicknamePageKey), findsOneWidget);
    });

    testWidgets('Pop and push between pages', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(WidgetKeys.phoneTextFieldKey), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(WidgetKeys.carTextFieldKey), number1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(WidgetKeys.nicknameTextFieldKey), nickname1);
      final NavigatorState navigator =
          tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();
      TextField textField =
          find.byKey(WidgetKeys.phoneTextFieldKey).evaluate().toList().first.widget;
      expect(textField.controller.value.text, phone1);
      await tester.enterText(find.byKey(WidgetKeys.phoneTextFieldKey), phone1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      textField =
          find.byKey(WidgetKeys.carTextFieldKey).evaluate().toList().first.widget;
      expect(textField.controller.value.text, number1);
      await tester.enterText(find.byKey(WidgetKeys.carTextFieldKey), number1);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      textField =
          find.byKey(WidgetKeys.nicknameTextFieldKey).evaluate().toList().first.widget;
      expect(textField.controller.value.text, nickname1);
    });
  });

  group('park', () {
    testWidgets('start parking success', (WidgetTester tester) async {
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
      user1[parkingKey] = parking1;
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
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

  group('car', () {
    testWidgets('add car success', (WidgetTester tester) async {
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WidgetKeys.userTabKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.userPageKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.addKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.removeKey), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.addKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.carPageKey), findsOneWidget);
      await tester.enterText(find.byKey(WidgetKeys.carTextFieldKey), number2);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.nicknamePageKey), findsOneWidget);
      when(model.networkProxy.sendAdd(userId1, number2, nickname2, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode({carKey: car2}),
              });
      await tester.enterText(find.byKey(WidgetKeys.nicknameTextFieldKey), nickname2);
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
      expect(find.byKey(Key(carId2)), findsOneWidget);
    });

    testWidgets('remove car success', (WidgetTester tester) async {
      user1[carsKey] = [car1, car2];
      model.localDBProxy.inMemoryUser = jsonEncode(user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WidgetKeys.userTabKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WidgetKeys.removeKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.selectCarPageKey), findsOneWidget);
      expect(find.byKey(Key(carId2)), findsOneWidget);
      when(model.networkProxy.sendRemove(userId1, carId2, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode({carKey: car2}),
              });
      await tester.tap(find.byKey(Key(carId2)));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.homePageKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.startKey), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.startKey));
      await tester.pumpAndSettle();
      expect(find.byKey(WidgetKeys.selectCarPageKey), findsOneWidget);
      expect(find.byKey(Key(carId2)), findsNothing);
    });
  });
}

class MockLocationProxy extends Mock implements LocationProxy {}

class MockNetworkProxy extends Mock implements NetworkProxy {}
