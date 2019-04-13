// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pango_lite/main.dart';
import 'package:pango_lite/model/elements/account.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class MockNetworkProxy extends Mock implements NetworkProxy {}

class MockLocalDB extends Mock implements LocalDBProxy {}

void main() {
  group('login', () {
    testWidgets('Not logged in', (WidgetTester tester) async {
      model = Model(MockNetworkProxy(), MockLocalDB());
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(Key('PhonePage')), findsOneWidget);
    });

    testWidgets('Already logged in', (WidgetTester tester) async {
      model = Model(MockNetworkProxy(), MockLocalDB());
      when(model.localDBProxy.loadAccount()).thenReturn(Account({}));
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
    });

    testWidgets('Login success', (WidgetTester tester) async {
      model = Model(MockNetworkProxy(), MockLocalDB());
      String phone = '1';
      String number = '2';
      when(model.networkProxy.login(phone, number)).thenAnswer((_) async => {});
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      when(model.localDBProxy.loadAccount()).thenReturn(Account({}));
      await tester.enterText(find.byKey(new Key('PhoneTextField')), phone);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('CarPage')), findsOneWidget);
      await tester.enterText(find.byKey(new Key('CarTextField')), number);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
    });

    testWidgets('Login failed', (WidgetTester tester) async {
      model = Model(MockNetworkProxy(), MockLocalDB());
      String phone = '1';
      String number = '2';
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(new Key('PhoneTextField')), phone);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('CarPage')), findsOneWidget);
      await tester.enterText(find.byKey(new Key('CarTextField')), number);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('PhonePage')), findsOneWidget);
    });
  });
}
