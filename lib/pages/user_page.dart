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
  bool isDirty = true;

  @override
  Widget build(BuildContext context) {
    if (isDirty) {
      vm.init().then((_) {});
      isDirty = false;
    }
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: UserPageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          switch (action.state) {
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
                      children: items.map(_buildItem).toList()));
            default:
              return Container();
          }
        });
  }

  @override
  void dispose() {
    vm.close();
    super.dispose();
  }

  @override
  void initState() {
    vm = UserPageVM();
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case UserPageVMOtherActionState.carPage:
          Navigator.pushNamed(context, Routes.carPage);
          break;
        case UserPageVMOtherActionState.selectCarPage:
          Navigator.pushNamed(context, Routes.selectCarPage);
          break;
        case UserPageVMOtherActionState.rootPage:
          Navigator.of(context).pushReplacementNamed(Routes.rootPage);
          break;
        default:
          break;
      }
      isDirty = true;
    });
    super.initState();
  }

  Widget _buildItem(UserPageVMItem item) {
    switch (item.type) {
      case UserPageVMItemType.blue:
        return Card(
          color: Colors.blue,
          child: ListTile(),
        );
      case UserPageVMItemType.orange:
        return Card(
          color: Colors.orange,
          child: ListTile(),
        );
      case UserPageVMItemType.add:
        return Card(
            key: WidgetKeys.addKey,
            child: ListTile(
              title: Column(
                  children: [Text(AppLocalizations.of(context).addCarLabel)]),
              onTap: () {
                vm.addCar();
              },
            ));
      case UserPageVMItemType.remove:
        return Card(
            key: WidgetKeys.removeKey,
            child: ListTile(
              title: Column(children: [
                Text(AppLocalizations.of(context).removeCarLabel)
              ]),
              onTap: () {
                vm.removeCar();
              },
            ));
      case UserPageVMItemType.exit:
        return Card(
            key: WidgetKeys.exitKey,
            child: ListTile(
              title: Column(
                  children: [Text(AppLocalizations.of(context).exitLabel)]),
              onTap: () async {
                vm.exit();
              },
            ));
      default:
        return Container();
    }
  }
}
