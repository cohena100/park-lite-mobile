import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/home_page_vm.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: WidgetKeys.homePageKey);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HomePageVM vm;

  @override
  Widget build(BuildContext context) {
    vm = HomePageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case HomePageVMOtherActionState.none:
          break;
        case HomePageVMOtherActionState.selectCarPage:
          Navigator.pushNamed(context, Routes.selectCarPage);
          break;
      }
    });
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: HomePageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          switch (action.state) {
            case HomePageVMActionState.none:
              return Container();
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
                    children: items.map(_buildItem).toList()),
              );
          }
        });
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }

  Widget _buildItem(HomePageVMItem item) {
    switch (item.type) {
      case HomePageVMItemType.none:
        return Container();
      case HomePageVMItemType.blue:
        return Card(
          key: WidgetKeys.blueKey,
          color: Colors.blue,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case HomePageVMItemType.orange:
        return Card(
          key: WidgetKeys.orangeKey,
          color: Colors.orange,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case HomePageVMItemType.start:
        return InkWell(
          child: Card(
            key: WidgetKeys.startKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                  child: Text(AppLocalizations.of(context).startParkingLabel)),
            ),
          ),
          onTap: () {
            vm.startParking();
          },
        );
      case HomePageVMItemType.stop:
        return InkWell(
          child: Card(
            key: WidgetKeys.stopKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                  child: Text(AppLocalizations.of(context).stopParkingLabel)),
            ),
          ),
          onTap: () async {
            await vm.stopParking();
          },
        );
    }
    return Container();
  }
}
