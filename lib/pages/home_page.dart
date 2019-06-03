import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/parking.dart';
import 'package:pango_lite/pages/home_page_vm.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: WidgetKeys.homePageKey);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HomePageVM vm = HomePageVM();
  bool isDirty = true;

  @override
  Widget build(BuildContext context) {
    if (isDirty) {
      vm.init().then((_) {});
      isDirty = false;
    }
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
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case HomePageVMOtherActionState.selectCarPage:
          Navigator.pushNamed(context, Routes.selectCarPage);
          break;
        case HomePageVMOtherActionState.carPage:
          Navigator.pushNamed(context, Routes.carPage);
          break;
        case HomePageVMOtherActionState.rootPage:
          Navigator.of(context).popAndPushNamed(Routes.rootPage);
          break;
      }
      isDirty = true;
    });
    super.initState();
  }

  Widget _buildItem(HomePageVMItem item) {
    switch (item.type) {
      case HomePageVMItemType.blue:
        return Card(
            key: WidgetKeys.blueKey,
            color: Colors.blue,
            child:
                Padding(padding: const EdgeInsets.all(24), child: Container()));
      case HomePageVMItemType.orange:
        return Card(
            key: WidgetKeys.orangeKey,
            color: Colors.orange,
            child:
                Padding(padding: const EdgeInsets.all(24), child: Container()));
      case HomePageVMItemType.start:
        return InkWell(
            child: Card(
                key: WidgetKeys.startKey,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                        child: Text(
                            AppLocalizations.of(context).startParkingLabel,
                            key: WidgetKeys.startTextKey)))),
            onTap: () {
              vm.startParking();
            });
      case HomePageVMItemType.stop:
        final Parking parking = item.data[HomePageVMItemDataKey.parking];
        final Car car = item.data[HomePageVMItemDataKey.car];
        return InkWell(
            child: Card(
                key: WidgetKeys.stopKey,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                        child: Column(children: [
                      Text(AppLocalizations.of(context).stopParkingLabel),
                      Text('${car.nickname} (${car.number})'),
                      Text(parking.cityName),
                      Text(parking.areaName),
                      Text(parking.rateName),
                    ])))),
            onTap: () async {
              await vm.stopParking();
            });
      case HomePageVMItemType.add:
        return InkWell(
            child: Card(
                key: WidgetKeys.addKey,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                        child:
                            Text(AppLocalizations.of(context).addCarLabel)))),
            onTap: () {
              vm.addCar();
            });
      case HomePageVMItemType.parking:
        final Parking parking = item.data[HomePageVMItemDataKey.parking];
        final Car car = item.data[HomePageVMItemDataKey.car];
        return InkWell(
            child: Card(
                key: Key(parking.id),
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                        child: Column(children: [
                      Text(
                        AppLocalizations.of(context).startPreviousParkingLabel,
                        key: Key(parking.id + 'Text'),
                      ),
                      Text('${car.nickname} (${car.number})'),
                      Text(parking.cityName),
                      Text(parking.areaName),
                      Text(parking.rateName),
                    ])))),
            onTap: () async {
              await vm.startPreviousParking(parking, car);
            });
      default:
        return Container();
    }
  }
}
