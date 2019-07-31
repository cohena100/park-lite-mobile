import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/blocs/user_bloc.dart';
import 'package:pango_lite/model/proxies/bluetooth_proxy.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/model/proxies/notification_proxy.dart';

Model model = Model(
  NetworkProxy(),
  LocalDbProxy(),
  LocationProxy(),
  BluetoothProxy(),
  NotificationProxy(),
);

class Model {
  final NetworkProxy networkProxy;
  final LocalDbProxy localDbProxy;
  final LocationProxy locationProxy;
  final BluetoothProxy bluetoothProxy;
  final NotificationProxy notificationProxy;
  final UserBloc userBloc;
  final ParkBloc parkBloc;

  Model(
    this.networkProxy,
    this.localDbProxy,
    this.locationProxy,
    this.bluetoothProxy,
    this.notificationProxy,
  )   : userBloc = UserBloc(
          networkProxy,
          localDbProxy,
        ),
        parkBloc = ParkBloc(
          localDbProxy,
          networkProxy,
          locationProxy,
          bluetoothProxy,
          notificationProxy,
        );

  void close() {
    userBloc.close();
    parkBloc.close();
  }

  void setup(bool isIOS) {
    networkProxy.setup(isIOS);
  }
}
