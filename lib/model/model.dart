import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/blocs/user_bloc.dart';
import 'package:pango_lite/model/proxies/bluetooth_proxy.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/model/proxies/notification_proxy.dart';

var model = Model(
  NetworkProxy(),
  LocalDBProxy(),
  LocationProxy(),
  BluetoothProxy(),
  NotificationProxy(),
);

class Model {
  final NetworkProxy networkProxy;
  final LocalDBProxy localDBProxy;
  final LocationProxy locationProxy;
  final BluetoothProxy bluetoothProxy;
  final NotificationProxy notificationProxy;
  final UserBloc userBloc;
  final ParkBloc parkBloc;

  Model(
    this.networkProxy,
    this.localDBProxy,
    this.locationProxy,
    this.bluetoothProxy,
    this.notificationProxy,
  )   : userBloc = UserBloc(
          networkProxy,
          localDBProxy,
        ),
        parkBloc = ParkBloc(
          localDBProxy,
          networkProxy,
          locationProxy,
          bluetoothProxy,
          notificationProxy,
        );

  void setup(bool isIOS) {
    networkProxy.setup(isIOS);
  }
}
