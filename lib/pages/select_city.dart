import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/elements/city.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/select_city_vm.dart';
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
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: SelectCityPageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          Widget body;
          switch (action.state) {
            case SelectCityPageVMActionState.cities:
              final List<SelectCityPageVMItem> items =
                  action.data[SelectCityPageVMActionDataKey.items];
              body = Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                      key: WidgetKeys.selectCityPageListViewKey,
                      children: items.map(_buildItem).toList()));
              break;
            default:
              body = Container();
          }
          return Scaffold(
              appBar: AppBar(
                  title: Text(AppLocalizations.of(context).selectCityTitle)),
              body: body);
        });
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }

  Widget _buildItem(SelectCityPageVMItem item) {
    switch (item.type) {
      case SelectCityPageVMItemType.none:
        return Container();
      case SelectCityPageVMItemType.blue:
        return Card(
            key: WidgetKeys.blueKey,
            color: Colors.blue,
            child:
                Padding(padding: const EdgeInsets.all(24), child: Container()));
      case SelectCityPageVMItemType.orange:
        return Card(
            key: WidgetKeys.orangeKey,
            color: Colors.orange,
            child:
                Padding(padding: const EdgeInsets.all(24), child: Container()));
      case SelectCityPageVMItemType.city:
        final City city = item.data[SelectCityPageVMItemDataKey.city];
        return InkWell(
            child: Card(
                key: Key(city.id),
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: Text('${city.name}')))),
            onTap: () {
              vm.selectCity(city);
            });
    }
    return Container();
  }
}
