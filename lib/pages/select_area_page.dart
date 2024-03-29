import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/elements/area.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/select_area_page_vm.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class SelectAreaPage extends StatefulWidget {
  SelectAreaPage({Key key}) : super(key: WidgetKeys.selectAreaPageKey);

  @override
  SelectAreaPageState createState() => SelectAreaPageState();
}

class SelectAreaPageState extends State<SelectAreaPage> {
  SelectAreaPageVM vm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(AppLocalizations.of(context).selectAreaTitle)),
        body: StreamBuilder(
            stream: vm.actionStream,
            initialData: SelectAreaPageVMAction(),
            builder: (context, snapshot) {
              final action = snapshot.data;
              Widget body;
              switch (action.state) {
                case SelectAreaPageVMActionState.none:
                  body = Container();
                  break;
                case SelectAreaPageVMActionState.areas:
                  final List<SelectAreaPageVMItem> items =
                      action.data[SelectAreaPageVMActionDataKey.items];
                  body = ListView(
                      key: WidgetKeys.selectAreaPageListViewKey,
                      children: items.map(_buildItem).toList());
                  break;
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
    vm = SelectAreaPageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case SelectAreaPageVMOtherActionState.selectRatePage:
          Navigator.pushNamed(context, Routes.selectRatePage);
          break;
        default:
          break;
      }
    });
    super.initState();
  }

  Widget _buildItem(SelectAreaPageVMItem item) {
    switch (item.type) {
      case SelectAreaPageVMItemType.blue:
        return Card(
          color: Colors.blue,
          child: ListTile(),
        );
      case SelectAreaPageVMItemType.orange:
        return Card(
          color: Colors.orange,
          child: ListTile(),
        );
      case SelectAreaPageVMItemType.area:
        final Area area = item.data[SelectAreaPageVMItemDataKey.area];
        return Card(
            key: Key(area.id),
            child: ListTile(
              title: Column(children: [
                Text('${area.name}'),
              ]),
              onTap: () {
                vm.selectArea(area);
              },
            ));
      default:
        return Container();
    }
  }
}
