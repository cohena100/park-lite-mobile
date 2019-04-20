import 'package:flutter/material.dart';
import 'package:pango_lite/pages/select_area_vm.dart';
import 'package:pango_lite/locale/locale.dart';

class SelectAreaPage extends StatefulWidget {
  SelectAreaPage({Key key}) : super(key: Key('SelectAreaPage'));

  @override
  SelectAreaPageState createState() => SelectAreaPageState();
}

class SelectAreaPageState extends State<SelectAreaPage> {
  SelectAreaPageVM vm;

  @override
  Widget build(BuildContext context) {
    vm = SelectAreaPageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case SelectAreaPageVMOtherActionState.none:
          break;
      }
    });
    return StreamBuilder(
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
              body = Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                    key: Key('SelectAreaPageListView'),
                    children: items.map(_buildItem).toList()),
              );
              break;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).selectAreaTitle),
            ),
            body: body,
          );
        });
  }

  Widget _buildItem(SelectAreaPageVMItem item) {
    switch (item.type) {
      case SelectAreaPageVMItemType.none:
        return Container();
      case SelectAreaPageVMItemType.blue:
        return Container(
          color: Colors.blue,
          child: ListTile(
            key: Key('Blue'),
          ),
        );
      case SelectAreaPageVMItemType.orange:
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
