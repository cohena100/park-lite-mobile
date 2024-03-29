import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/elements/rate.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/select_rate_page_vm.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class SelectRatePage extends StatefulWidget {
  SelectRatePage({Key key}) : super(key: WidgetKeys.selectRatePageKey);

  @override
  SelectRatePageState createState() => SelectRatePageState();
}

class SelectRatePageState extends State<SelectRatePage> {
  SelectRatePageVM vm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(AppLocalizations.of(context).selectRateTitle)),
        body: StreamBuilder(
            stream: vm.actionStream,
            initialData: SelectRatePageVMAction(),
            builder: (context, snapshot) {
              final action = snapshot.data;
              Widget body;
              switch (action.state) {
                case SelectRatePageVMActionState.rates:
                  final List<SelectRatePageVMItem> items =
                      action.data[SelectRatePageVMActionDataKey.items];
                  body = ListView(
                      key: WidgetKeys.selectRatePageListViewKey,
                      children: items.map(_buildItem).toList());
                  break;
                case SelectRatePageVMActionState.busy:
                  body = Center(child: CircularProgressIndicator());
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
    vm = SelectRatePageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case SelectRatePageVMOtherActionState.rootPage:
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.rootPage));
          break;
        default:
          break;
      }
    });
    super.initState();
  }

  Widget _buildItem(SelectRatePageVMItem item) {
    switch (item.type) {
      case SelectRatePageVMItemType.none:
        return Container();
      case SelectRatePageVMItemType.blue:
        return Card(
          color: Colors.blue,
          child: ListTile(),
        );
      case SelectRatePageVMItemType.orange:
        return Card(
          color: Colors.orange,
          child: ListTile(),
        );
      case SelectRatePageVMItemType.rate:
        final Rate rate = item.data[SelectRatePageVMItemDataKey.rate];
        return Card(
            key: Key(rate.id),
            child: ListTile(
              title: Column(children: [
                Text('${rate.name}'),
              ]),
              onTap: () async {
                final rate = item.data[SelectRatePageVMItemDataKey.rate];
                await vm.selectRate(rate);
              },
            ));
    }
    return Container();
  }
}
