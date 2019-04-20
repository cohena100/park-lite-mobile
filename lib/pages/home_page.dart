import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/home_page_vm.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: Key('HomePage'));

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
          Navigator.pushNamed(context, '/selectCar');
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
            case HomePageVMActionState.home:
              final List<HomePageVMItem> items =
                  action.data[HomePageVMActionDataKey.items];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                    key: Key('HomePageListView'),
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
        return Container(
          color: Colors.blue,
          child: ListTile(
            key: Key('Blue'),
          ),
        );
      case HomePageVMItemType.orange:
        return Container(
          color: Colors.orange,
          child: ListTile(
            key: Key('White'),
          ),
        );
      case HomePageVMItemType.start:
        return Container(
          color: Colors.white,
          child: ListTile(
            key: Key('Start'),
            title: Center(
                child: Text(AppLocalizations.of(context).startParkingLabel)),
            onTap: () {
              vm.startParking();
            },
          ),
        );
    }
    return Container();
  }
}
