import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';

class Model {

  final NetworkProxyProvider networkProxy;
  final AccountBloc accountBloc;

  Model(this.networkProxy): accountBloc = AccountBloc(networkProxy);

}

var model = Model(NetworkProxy());
