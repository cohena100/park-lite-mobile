import 'package:flutter/material.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/select_car_page_vm.dart';
import 'package:pango_lite/locale/locale.dart';

class SelectCarPage extends StatefulWidget {
  SelectCarPage({Key key}) : super(key: Key('SelectCarPage'));

  @override
  SelectCarPageState createState() => SelectCarPageState();
}

class SelectCarPageState extends State<SelectCarPage> {
  SelectCarPageVM vm;

  @override
  Widget build(BuildContext context) {
    vm = SelectCarPageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case SelectCarPageVMOtherActionState.none:
          break;
        case SelectCarPageVMOtherActionState.selectCityPage:
          Navigator.pushNamed(context, Routes.selectCityPage);
          break;
      }
    });
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: SelectCarPageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          Widget body;
          switch (action.state) {
            case SelectCarPageVMActionState.none:
              body = Container();
              break;
            case SelectCarPageVMActionState.busy:
              body = Center(child: body = CircularProgressIndicator());
              break;
            case SelectCarPageVMActionState.cars:
              final List<SelectCarPageVMItem> items =
                  action.data[SelectCarPageVMActionDataKey.items];
              body = Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                    key: Key('SelectCarPageListView'),
                    children: items.map(_buildItem).toList()),
              );
              break;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).selectCarTitle),
            ),
            body: body,
          );
        });
  }

  Widget _buildItem(SelectCarPageVMItem item) {
    switch (item.type) {
      case SelectCarPageVMItemType.none:
        return Container();
      case SelectCarPageVMItemType.blue:
        return Card(
          key: Key('Blue'),
          color: Colors.blue,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case SelectCarPageVMItemType.orange:
        return Card(
          key: Key('Orange'),
          color: Colors.orange,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case SelectCarPageVMItemType.car:
        final number = item.data[SelectCarPageVMItemDataKey.number];
        final nickname = item.data[SelectCarPageVMItemDataKey.nickname];
        final car = item.data[SelectCarPageVMItemDataKey.car];
        return InkWell(
          child: Card(
            key: Key(number),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text('$nickname ($number)')),
            ),
          ),
          onTap: () async {
            await vm.selectCar(car);
          },
        );
    }
    return Container();
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }
}
