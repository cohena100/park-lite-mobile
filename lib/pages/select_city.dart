import 'package:flutter/material.dart';
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
        return Container(
          color: Colors.blue,
          child: ListTile(
            key: Key('Blue'),
          ),
        );
      case SelectCityPageVMItemType.orange:
        return Container(
          color: Colors.orange,
          child: ListTile(
            key: Key('White'),
          ),
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
