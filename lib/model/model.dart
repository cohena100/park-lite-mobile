import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class Model {
  final NetworkProxy networkProxy;
  final LocalDBProxy localDBProxy;
  final AccountBloc accountBloc;

  Model(this.networkProxy, this.localDBProxy)
      : accountBloc = AccountBloc(networkProxy, localDBProxy);

  void setup(bool isIOS) {
    networkProxy.setup(isIOS);
  }
}

var model = Model(NetworkProxy(), LocalDBProxy());
