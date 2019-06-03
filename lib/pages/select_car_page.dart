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
  SelectCarPageVM vm = SelectCarPageVM();
  bool isDirty = true;

  @override
  Widget build(BuildContext context) {
    if (isDirty) {
      vm.init().then((_) {});
      isDirty = false;
    }
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
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case SelectCarPageVMOtherActionState.selectCityPage:
          Navigator.pushNamed(context, Routes.selectCityPage);
          break;
        case SelectCarPageVMOtherActionState.rootPage:
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.rootPage));
          Navigator.of(context).pushReplacementNamed(Routes.rootPage);
          break;
        default:
          break;
      }
      isDirty = true;
    });
    super.initState();
  }

  Widget _buildItem(SelectCarPageVMItem item) {
    switch (item.type) {
      case SelectCarPageVMItemType.blue:
        return Card(
            key: WidgetKeys.blueKey,
            color: Colors.blue,
            child:
                Padding(padding: const EdgeInsets.all(24), child: Container()));
      case SelectCarPageVMItemType.orange:
        return Card(
            key: WidgetKeys.orangeKey,
            color: Colors.orange,
            child:
                Padding(padding: const EdgeInsets.all(24), child: Container()));
      case SelectCarPageVMItemType.car:
        final Car car = item.data[SelectCarPageVMItemDataKey.car];
        return InkWell(
            child: Card(
                key: Key(car.id),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(child: Text('${car.nickname} (${car.number})')),
                )),
            onTap: () async {
              await vm.selectCar(car);
            });
      default:
        return Container();
    }
  }
}
