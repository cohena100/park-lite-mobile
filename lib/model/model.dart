import 'package:flutter/material.dart';
import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:pango_lite/model/proxies/network_proxy.dart';
import 'package:pango_lite/pages/car_page.dart';
import 'package:pango_lite/pages/car_page_vm.dart';
import 'package:pango_lite/pages/home_page.dart';
import 'package:pango_lite/pages/home_page_vm.dart';
import 'package:pango_lite/pages/main_page.dart';
import 'package:pango_lite/pages/main_page_vm.dart';
import 'package:pango_lite/pages/phone_page.dart';
import 'package:pango_lite/pages/phone_page_vm.dart';

class Model {
  final NetworkProxyProvider networkProxy;
  final LocalDBProxyProvider localDBProxy;
  final AccountBloc accountBloc;

  Model(this.networkProxy, this.localDBProxy)
      : accountBloc = AccountBloc(networkProxy, localDBProxy);

  MainPage mainPage() {
    return MainPage(key: Key('MainPage'), vm: MainPageVM());
  }

  PhonePage phonePage() {
    return PhonePage(key: Key('PhonePage'), vm: PhonePageVM());
  }

  CarPage carPage(String phone) {
    return CarPage(key: Key('CarPage'), vm: CarPageVM(phone));
  }

  HomePage homePage() {
    return HomePage(key: Key('HomePage'), vm: HomePageVM());
  }
}

var model = Model(NetworkProxy(), LocalDBProxy());
