import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

var model = Model(NetworkProxy(), LocalDBProxy());

class Model {
  final NetworkProxy networkProxy;
  final LocalDBProxy localDBProxy;
  final AccountBloc accountBloc;
  final ParkBloc parkBloc;

  Model(this.networkProxy, this.localDBProxy)
      : accountBloc = AccountBloc(networkProxy, localDBProxy),
        parkBloc = ParkBloc(localDBProxy, networkProxy);

  void setup(bool isIOS) {
    networkProxy.setup(isIOS);
  }
}
