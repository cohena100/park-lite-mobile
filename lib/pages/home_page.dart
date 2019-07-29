import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/parking.dart';
import 'package:pango_lite/pages/home_page_vm.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/widget_keys.dart';

import 'base_page_vm.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: WidgetKeys.homePageKey);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with BasePageVM {
  HomePageVM vm;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: HomePageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          switch (action.state) {
            case HomePageVMActionState.busy:
              return Center(child: CircularProgressIndicator());
              break;
            case HomePageVMActionState.home:
              final List<HomePageVMItem> items =
                  action.data[HomePageVMActionDataKey.items];
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                      key: WidgetKeys.homePageListViewKey,
                      children: items.map(_buildItem).toList()));
            default:
              return Container();
              break;
          }
        });
  }

  @override
  void dispose() {
    vm.close();
    super.dispose();
  }

  @override
  void initState() {
    vm = HomePageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case HomePageVMOtherActionState.selectCarPage:
          Navigator.pushNamed(context, Routes.selectCarPage);
          break;
        case HomePageVMOtherActionState.carPage:
          Navigator.pushNamed(context, Routes.carPage);
          break;
        case HomePageVMOtherActionState.payPage:
          Navigator.of(context).pushNamed(Routes.payPage);
          break;
        case HomePageVMOtherActionState.rootPage:
          Navigator.of(context).pushReplacementNamed(Routes.rootPage);
          break;
      }
    });
    super.initState();
  }

  Widget _buildItem(HomePageVMItem item) {
    switch (item.type) {
      case HomePageVMItemType.blue:
        return Card(
          key: nextKey(),
          color: Colors.blue,
          child: ListTile(),
        );
      case HomePageVMItemType.orange:
        return Card(
          key: nextKey(),
          color: Colors.orange,
          child: ListTile(),
        );
      case HomePageVMItemType.start:
        return Card(
            key: WidgetKeys.startKey,
            child: ListTile(
              title: Column(
                children: <Widget>[
                  Text(AppLocalizations.of(context).startParkingLabel,
                      key: WidgetKeys.startTextKey),
                ],
              ),
              onTap: () {
                vm.startParking();
              },
            ));
      case HomePageVMItemType.stop:
        final Parking parking = item.data[HomePageVMItemDataKey.parking];
        final Car car = item.data[HomePageVMItemDataKey.car];
        return Card(
            key: WidgetKeys.stopKey,
            child: ListTile(
              title: Column(children: [
                Text(AppLocalizations.of(context).stopParkingLabel),
                Text('${car.nickname} (${car.number})'),
                Text(parking.cityName),
                Text(parking.areaName),
                Text(parking.rateName),
              ]),
              onTap: () async {
                await vm.endParking();
              },
            ));
      case HomePageVMItemType.add:
        return Card(
            key: WidgetKeys.addKey,
            child: ListTile(
              title: Column(children: [
                Text(AppLocalizations.of(context).addCarLabel),
              ]),
              onTap: () {
                vm.addCar();
              },
            ));
      case HomePageVMItemType.parking:
        final Parking parking = item.data[HomePageVMItemDataKey.parking];
        final Car car = item.data[HomePageVMItemDataKey.car];
        return Card(
            key: Key(parking.id),
            child: ListTile(
              title: Column(children: [
                Text(
                  AppLocalizations.of(context).startPreviousParkingLabel,
                  key: Key(parking.id + 'Text'),
                ),
                Text('${car.nickname} (${car.number})'),
                Text(parking.cityName),
                Text(parking.areaName),
                Text(parking.rateName),
              ]),
              onTap: () async {
                await vm.startPreviousParking(parking, car);
              },
            ));
      case HomePageVMItemType.pay:
        final Parking parking = item.data[HomePageVMItemDataKey.parking];
        final Car car = item.data[HomePageVMItemDataKey.car];
        return Card(
            key: WidgetKeys.payKey,
            child: ListTile(
              title: Column(children: [
                Text(AppLocalizations.of(context).payParkingLabel),
                Text('${car.nickname} (${car.number})'),
                Text(parking.cityName),
                Text(parking.areaName),
                Text(parking.rateName),
              ]),
              onTap: () {
                vm.payParking();
              },
            ));
      default:
        return Container();
    }
  }
}
