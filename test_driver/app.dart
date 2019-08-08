import 'dart:convert';

import 'package:flutter_driver/driver_extension.dart';
import 'package:mockito/mockito.dart';
import 'package:pango_lite/main.dart' as app;
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/bluetooth_proxy.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/model/proxies/notification_proxy.dart';
import 'package:pango_lite/playground/defs.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  user1 = {
    '_id': userId1,
    'phone': phone1,
    'token': token1,
    'cars': [car1, car2],
  };
  final cache = {
    'parkings': [
      parking1,
      parking2,
      parking3,
      parking4,
      parking5,
    ]
  };
  final bluetoothProxyStream = BehaviorSubject<bool>();
  Future<String> dataHandler(String msg) async {
    switch (msg) {
      case "reset":
        await model.localDbProxy.saveUser(jsonEncode(user1));
        await model.localDbProxy.saveCache(jsonEncode(cache));
        model.userBloc.seed();
        return "ok";
      case "teardown":
        await bluetoothProxyStream.close();
        return 'ok';
      default:
        return 'error';
    }
  }
  enableFlutterDriverExtension(handler: dataHandler);
  final localDbProxy = LocalDbProxy(isInTestModel: true);
  localDbProxy.geoPark = geoPark1;
  model = Model(
    MockNetworkProxy(),
    localDbProxy,
    MockLocationProxy(),
    MockBluetoothProxy(),
    MockNotificationProxy(),
  );
  when(model.bluetoothProxy.stream)
      .thenAnswer((_) => bluetoothProxyStream.stream);
  when(model.notificationProxy.showNotification(any, any)).thenAnswer((_) {
    return;
  });
  app.main();
}

class MockBluetoothProxy extends Mock implements BluetoothProxy {}

class MockLocationProxy extends Mock implements LocationProxy {}

class MockNetworkProxy extends Mock implements NetworkProxy {}

class MockNotificationProxy extends Mock implements NotificationProxy {}
