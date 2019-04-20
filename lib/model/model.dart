import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/location_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

var model = Model(NetworkProxy(), LocalDBProxy(), LocationProxy());

class Model {
  final NetworkProxy networkProxy;
  final LocalDBProxy localDBProxy;
  final LocationProxy locationProxy;
  final AccountBloc accountBloc;
  final ParkBloc parkBloc;

  Model(this.networkProxy, this.localDBProxy, this.locationProxy)
      : accountBloc = AccountBloc(networkProxy, localDBProxy),
        parkBloc = ParkBloc(localDBProxy, networkProxy, locationProxy);

  void setup(bool isIOS) {
    networkProxy.setup(isIOS);
  }
}
