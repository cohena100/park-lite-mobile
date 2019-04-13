import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class Model {
  final NetworkProxyProvider networkProxy;
  final LocalDBProxyProvider localDBProxy;
  final AccountBloc accountBloc;

  Model(this.networkProxy, this.localDBProxy)
      : accountBloc = AccountBloc(networkProxy, localDBProxy);
}

var model = Model(NetworkProxy(), LocalDBProxy());
