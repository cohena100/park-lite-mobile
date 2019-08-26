import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/elements/city.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/select_city_page_vm.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class SelectCityPage extends StatefulWidget {
  SelectCityPage({Key key}) : super(key: WidgetKeys.selectCityPageKey);

  @override
  SelectCityPageState createState() => SelectCityPageState();
}

class SelectCityPageState extends State<SelectCityPage> {
  SelectCityPageVM vm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(AppLocalizations.of(context).selectCityTitle)),
        body: StreamBuilder(
            stream: vm.actionStream,
            initialData: SelectCityPageVMAction(),
            builder: (context, snapshot) {
              final action = snapshot.data;
              Widget body;
              switch (action.state) {
                case SelectCityPageVMActionState.cities:
                  final List<SelectCityPageVMItem> items =
                      action.data[SelectCityPageVMActionDataKey.items];
                  body = ListView(
                      key: WidgetKeys.selectCityPageListViewKey,
                      children: items.map(_buildItem).toList());
                  break;
                default:
                  body = Container();
              }
              return body;
            }));
  }

  @override
  void dispose() {
    vm.close();
    super.dispose();
  }

  @override
  void initState() {
    vm = SelectCityPageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case SelectCityPageVMOtherActionState.selectAreaPage:
          Navigator.pushNamed(context, Routes.selectAreaPage);
          break;
        default:
          break;
      }
    });
    super.initState();
  }

  Widget _buildItem(SelectCityPageVMItem item) {
    switch (item.type) {
      case SelectCityPageVMItemType.none:
        return Container();
      case SelectCityPageVMItemType.blue:
        return Card(
          color: Colors.blue,
          child: ListTile(),
        );
      case SelectCityPageVMItemType.orange:
        return Card(
          color: Colors.orange,
          child: ListTile(),
        );
      case SelectCityPageVMItemType.city:
        final City city = item.data[SelectCityPageVMItemDataKey.city];
        return Card(
            key: Key(city.id),
            child: ListTile(
              title: Column(children: [
                Text('${city.name}'),
              ]),
              onTap: () {
                vm.selectCity(city);
              },
            ));
    }
    return Container();
  }
}
