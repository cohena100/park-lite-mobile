import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/pages/car_page_vm.dart';
import 'package:pango_lite/pages/home_page_vm.dart';
import 'package:pango_lite/pages/main_page_vm.dart';
import 'package:pango_lite/pages/phone_page_vm.dart';

class Model {
  final NetworkProxyProvider networkProxy;
  final LocalDBProxyProvider localDBProxy;
  final AccountBloc accountBloc;

  Model(this.networkProxy, this.localDBProxy)
      : accountBloc = AccountBloc(networkProxy, localDBProxy);

  MainPageVM mainPageVM() {
    return MainPageVM();
  }

  PhonePageVM phonePageVM() {
    return PhonePageVM();
  }

  CarPageVM carPageVM() {
    return CarPageVM();
  }

  HomePageVM homePageVM() {
    return HomePageVM();
  }
}

var model = Model(NetworkProxy(), LocalDBProxy());
