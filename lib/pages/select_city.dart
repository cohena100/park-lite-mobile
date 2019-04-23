import 'package:flutter/material.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/select_city_vm.dart';
import 'package:pango_lite/locale/locale.dart';

class SelectCityPage extends StatefulWidget {
  SelectCityPage({Key key}) : super(key: Key('SelectCityPage'));

  @override
  SelectCityPageState createState() => SelectCityPageState();
}

class SelectCityPageState extends State<SelectCityPage> {
  SelectCityPageVM vm;

  @override
  Widget build(BuildContext context) {
    vm = SelectCityPageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case SelectCityPageVMOtherActionState.none:
          break;
        case SelectCityPageVMOtherActionState.rate:
          Navigator.pushNamed(context, Routes.selectRatePage);
          break;
      }
    });
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: SelectCityPageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          Widget body;
          switch (action.state) {
            case SelectCityPageVMActionState.none:
              body = Container();
              break;
            case SelectCityPageVMActionState.cities:
              final List<SelectCityPageVMItem> items =
                  action.data[SelectCityPageVMActionDataKey.items];
              body = Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                    key: Key('SelectCityPageListView'),
                    children: items.map(_buildItem).toList()),
              );
              break;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).selectCityTitle),
            ),
            body: body,
          );
        });
  }

  Widget _buildItem(SelectCityPageVMItem item) {
    switch (item.type) {
      case SelectCityPageVMItemType.none:
        return Container();
      case SelectCityPageVMItemType.blue:
        return Card(
          key: Key('Blue'),
          color: Colors.blue,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case SelectCityPageVMItemType.orange:
        return Card(
          key: Key('Orange'),
          color: Colors.orange,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case SelectCityPageVMItemType.city:
        final name = item.data[SelectCityPageVMItemDataKey.name];
        final id = item.data[SelectCityPageVMItemDataKey.id];
        final city = item.data[SelectCityPageVMItemDataKey.city];
        return InkWell(
          child: Card(
            key: Key(id.toString()),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text('$name')),
            ),
          ),
          onTap: () {
            vm.selectCity(city);
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