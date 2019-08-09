// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Home page', () {
    final parking5CardFinder = find.byValueKey('5');
    final parking1CardFinder = find.byValueKey('1');
    final listFinder = find.byValueKey('HomePageListView');
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.requestData('teardown');
      if (driver != null) {
        await driver.close();
      }
    });

    test('show last 3 parkings on home page', () async {
      await driver.waitFor(parking5CardFinder, timeout: Duration(seconds: 1));
      await driver.waitForAbsent(parking1CardFinder,
          timeout: Duration(seconds: 1));
      await driver.scrollUntilVisible(
        listFinder,
        parking1CardFinder,
        dyScroll: -300.0,
      );
      await driver.waitFor(parking1CardFinder, timeout: Duration(seconds: 1));
      await driver.waitForAbsent(parking5CardFinder,
          timeout: Duration(seconds: 1));
    });
  });
}
