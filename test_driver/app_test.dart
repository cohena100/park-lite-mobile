// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Home page', () {
    final parking3TextFinder = find.byValueKey('3Text');
    final parking1TextFinder = find.byValueKey('1Text');
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
      expect(
          await driver.getText(
            parking3TextFinder,
            timeout: Duration(seconds: 1),
          ),
          isNotNull);
      await driver.scrollUntilVisible(
        listFinder,
        parking1TextFinder,
        dyScroll: -300.0,
      );
      expect(
          await driver.getText(parking1TextFinder,
              timeout: Duration(seconds: 1)),
          isNotNull);
    });
  });
}
