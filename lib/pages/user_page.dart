import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/user_page_vm.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: WidgetKeys.userPageKey);

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  UserPageVM vm;

  @override
  Widget build(BuildContext context) {
    vm = UserPageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case UserPageVMOtherActionState.none:
          break;
        case UserPageVMOtherActionState.carPage:
          Navigator.pushNamed(context, Routes.carPage);
          break;
        case UserPageVMOtherActionState.selectCarPage:
          Navigator.pushNamed(context, Routes.selectCarPage);
      }
    });
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: UserPageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          switch (action.state) {
            case UserPageVMActionState.none:
              return Container();
            case UserPageVMActionState.busy:
              return Center(child: CircularProgressIndicator());
              break;
            case UserPageVMActionState.user:
              final List<UserPageVMItem> items =
                  action.data[UserPageVMActionDataKey.items];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                    key: WidgetKeys.userPageListViewKey,
                    children: items.map(_buildItem).toList()),
              );
          }
        });
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }

  Widget _buildItem(UserPageVMItem item) {
    switch (item.type) {
      case UserPageVMItemType.none:
        return Container();
      case UserPageVMItemType.blue:
        return Card(
          key: WidgetKeys.blueKey,
          color: Colors.blue,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case UserPageVMItemType.orange:
        return Card(
          key: WidgetKeys.orangeKey,
          color: Colors.orange,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case UserPageVMItemType.add:
        return InkWell(
          child: Card(
            key: WidgetKeys.addKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child:
                  Center(child: Text(AppLocalizations.of(context).addCarLabel)),
            ),
          ),
          onTap: () {
            vm.addCar();
          },
        );
      case UserPageVMItemType.remove:
        return InkWell(
          child: Card(
            key: WidgetKeys.removeKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                  child: Text(AppLocalizations.of(context).removeCarLabel)),
            ),
          ),
          onTap: () {
            vm.removeCar();
          },
        );
    }
    return Container();
  }
}
