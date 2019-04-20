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
      when(model.localDBProxy.loadAccount()).thenAnswer((_) async => {});
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
    });

    testWidgets('Login success', (WidgetTester tester) async {
      model = Model(MockNetworkProxy(), MockLocalDB());
      String phone = '1';
      String number = '2';
      String nickname = 'a';
      when(model.networkProxy.sendLogin(phone, number, nickname)).thenAnswer(
          (_) async => {NetworkProxyKeys.code: 200, NetworkProxyKeys.body: ''});
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      when(model.localDBProxy.loadAccount()).thenAnswer((_) async => {});
      await tester.enterText(find.byKey(Key('PhoneTextField')), phone);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('CarPage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('CarTextField')), number);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('NicknamePage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('NicknameTextField')), nickname);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
    });

    testWidgets('Login failed', (WidgetTester tester) async {
      model = Model(MockNetworkProxy(), MockLocalDB());
      String phone = '1';
      String number = '2';
      String nickname = 'a';
      when(model.networkProxy.sendLogin(phone, number, nickname)).thenAnswer(
          (_) async => {NetworkProxyKeys.code: 400, NetworkProxyKeys.body: ''});
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('PhoneTextField')), phone);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('CarPage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('CarTextField')), number);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('NicknamePage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('NicknameTextField')), nickname);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.byKey(Key('NicknamePage')), findsOneWidget);
    });

    testWidgets('Pop and push between pages', (WidgetTester tester) async {
      model = Model(MockNetworkProxy(), MockLocalDB());
      String phone = '1';
      String number = '2';
      String nickname = 'a';
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('PhoneTextField')), phone);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('CarTextField')), number);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('NicknameTextField')), nickname);
      final NavigatorState navigator =
          tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();
      TextField textField =
          find.byKey(Key('PhoneTextField')).evaluate().toList().first.widget;
      expect(textField.controller.value.text, phone);
      await tester.enterText(find.byKey(Key('PhoneTextField')), phone);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      textField =
          find.byKey(Key('CarTextField')).evaluate().toList().first.widget;
      expect(textField.controller.value.text, number);
      await tester.enterText(find.byKey(Key('CarTextField')), number);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      textField =
          find.byKey(Key('NicknameTextField')).evaluate().toList().first.widget;
      expect(textField.controller.value.text, nickname);
    });
    testWidgets('Validate success', (WidgetTester tester) async {
      model = Model(MockNetworkProxy(), MockLocalDB());
      String phone = '1';
      String number = '2';
      String nickname = 'a';
      String code = '3';
      when(model.networkProxy.sendLogin(phone, number, nickname)).thenAnswer(
          (_) async => {NetworkProxyKeys.code: 401, NetworkProxyKeys.body: ''});
      when(model.networkProxy.sendValidate(phone, number, code)).thenAnswer(
          (_) async => {NetworkProxyKeys.code: 200, NetworkProxyKeys.body: ''});
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      when(model.localDBProxy.loadAccount()).thenAnswer((_) async => {});
      await tester.enterText(find.byKey(Key('PhoneTextField')), phone);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('CarPage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('CarTextField')), number);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('NicknamePage')), findsOneWidget);
      await tester.enterText(find.byKey(Key('NicknameTextField')), nickname);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('ValidatePage')), findsOneWidget);
      await tester.enterText(
          find.byKey(Key('ValidateTextField')), code);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('HomePage')), findsOneWidget);
    });
  });
}
