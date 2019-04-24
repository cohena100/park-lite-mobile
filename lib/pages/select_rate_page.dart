import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/select_rate_page_vm.dart';

class SelectRatePage extends StatefulWidget {
  SelectRatePage({Key key}) : super(key: Key('SelectRatePage'));

  @override
  SelectRatePageState createState() => SelectRatePageState();
}

class SelectRatePageState extends State<SelectRatePage> {
  SelectRatePageVM vm;

  @override
  Widget build(BuildContext context) {
    vm = SelectRatePageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case SelectRatePageVMOtherActionState.none:
          break;
        case SelectRatePageVMOtherActionState.home:
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.rootPage));
      }
    });
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: SelectRatePageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          Widget body;
          switch (action.state) {
            case SelectRatePageVMActionState.none:
              body = Container();
              break;
            case SelectRatePageVMActionState.rates:
              final List<SelectRatePageVMItem> items =
                  action.data[SelectRatePageVMActionDataKey.items];
              body = Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                    key: Key('SelectRatePageListView'),
                    children: items.map(_buildItem).toList()),
              );
              break;
            case SelectRatePageVMActionState.busy:
              body = Center(child: CircularProgressIndicator());
              break;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).selectRateTitle),
            ),
            body: body,
          );
        });
  }

  Widget _buildItem(SelectRatePageVMItem item) {
    switch (item.type) {
      case SelectRatePageVMItemType.none:
        return Container();
      case SelectRatePageVMItemType.blue:
        return Card(
          key: Key('Blue'),
          color: Colors.blue,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case SelectRatePageVMItemType.orange:
        return Card(
          key: Key('Orange'),
          color: Colors.orange,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case SelectRatePageVMItemType.rate:
        final name = item.data[SelectRatePageVMItemDataKey.name];
        final id = item.data[SelectRatePageVMItemDataKey.id];
        return InkWell(
          child: Card(
            key: Key(id.toString()),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text('$name')),
            ),
          ),
          onTap: () async {
            final rate = item.data[SelectRatePageVMItemDataKey.rate];
            await vm.selectRate(rate);
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
