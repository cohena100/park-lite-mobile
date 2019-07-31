import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/select_car_page_vm.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class SelectCarPage extends StatefulWidget {
  SelectCarPage({Key key}) : super(key: WidgetKeys.selectCarPageKey);

  @override
  SelectCarPageState createState() => SelectCarPageState();
}

class SelectCarPageState extends State<SelectCarPage> {
  SelectCarPageVM vm;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: SelectCarPageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          Widget body;
          switch (action.state) {
            case SelectCarPageVMActionState.busy:
              body = Center(child: CircularProgressIndicator());
              break;
            case SelectCarPageVMActionState.cars:
              final List<SelectCarPageVMItem> items =
                  action.data[SelectCarPageVMActionDataKey.items];
              body = Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                    key: WidgetKeys.selectCarPageListViewKey,
                    children: items.map(_buildItem).toList()),
              );
              break;
            default:
              body = Container();
              break;
          }
          return Scaffold(
              appBar: AppBar(
                  title: Text(AppLocalizations.of(context).selectCarTitle)),
              body: body);
        });
  }

  @override
  void dispose() {
    vm.close();
    super.dispose();
  }

  @override
  void initState() {
    vm = SelectCarPageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case SelectCarPageVMOtherActionState.selectCityPage:
          Navigator.pushNamed(context, Routes.selectCityPage);
          break;
        case SelectCarPageVMOtherActionState.rootPage:
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.rootPage));
          break;
        default:
          break;
      }
    });
    super.initState();
  }

  Widget _buildItem(SelectCarPageVMItem item) {
    switch (item.type) {
      case SelectCarPageVMItemType.blue:
        return Card(
          color: Colors.blue,
          child: ListTile(),
        );
      case SelectCarPageVMItemType.orange:
        return Card(
          color: Colors.orange,
          child: ListTile(),
        );
      case SelectCarPageVMItemType.car:
        final Car car = item.data[SelectCarPageVMItemDataKey.car];
        return Card(
            key: Key(car.id),
            child: ListTile(
              title:
                  Column(children: [Text('${car.nickname} (${car.number})')]),
              onTap: () async {
                await vm.selectCar(car);
              },
            ));
      default:
        return Container();
    }
  }
}
