// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:pango_lite/playground/defs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
      when(model.networkProxy.sendLogin(phone1, number1, nickname1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode({userKey: user1}),
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
  });

  group('park', () {
    testWidgets('start parking success', (WidgetTester tester) async {
      model =
          Model(MockNetworkProxy(), MockLocalDBProxy(), MockLocationProxy());
      when(model.localDBProxy.loadUser()).thenAnswer((_) async => user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
      expect(find.byKey(Key('Start')), findsOneWidget);
      await tester.tap(find.byKey(Key('Start')));
      await tester.pumpAndSettle();
      when(model.locationProxy.currentLocation)
          .thenAnswer((_) async => location1);
      when(model.localDBProxy.loadGeoPark()).thenReturn(geoPark1);
      expect(find.byKey(Key('SelectCarPage')), findsOneWidget);
      await tester.tap(find.byKey(Key(carId1)));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('SelectCityPage')), findsOneWidget);
      await tester.tap(find.byKey(Key(cityId1)));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('SelectAreaPage')), findsOneWidget);
      await tester.tap(find.byKey(Key(areaId1)));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('SelectRatePage')), findsOneWidget);
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
      expect(find.byKey(Key('Stop')), findsOneWidget);
    });

    testWidgets('stop parking success', (WidgetTester tester) async {
      model =
          Model(MockNetworkProxy(), MockLocalDBProxy(), MockLocationProxy());
      user1[parkingKey] = parking1;
      when(model.localDBProxy.loadUser()).thenAnswer((_) async => user1);
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      when(model.networkProxy.sendStop(userId1, parkingId1, token1))
          .thenAnswer((_) async => {
                NetworkProxyKeys.code: 200,
                NetworkProxyKeys.body: jsonEncode({parkingKey: parking1}),
              });
      await tester.tap(find.byKey(Key('Stop')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
      expect(find.byKey(Key('Start')), findsOneWidget);
    });
  });
}
