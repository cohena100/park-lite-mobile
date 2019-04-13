// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide group;
import 'package:pango_lite/model/elements/account.dart';
import 'package:test/test.dart' show group;
import 'package:pango_lite/main.dart';
import 'package:pango_lite/model/model.dart';

void main() {
  testWidgets('Not logged in', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(find.byKey(Key('PhonePage')), findsOneWidget);
  });

  testWidgets('Already logged in', (WidgetTester tester) async {
    model.localDBProxy.saveAccount(Account({}));
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(find.byKey(Key('HomePage')), findsOneWidget);
  });
}
