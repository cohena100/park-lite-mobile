import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/user_page_vm.dart';
import 'package:pango_lite/pages/routes.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: Key('UserPage'));

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
                    key: Key('UserPageListView'),
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
          key: Key('Blue'),
          color: Colors.blue,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case UserPageVMItemType.orange:
        return Card(
          key: Key('Orange'),
          color: Colors.orange,
          child: Padding(padding: const EdgeInsets.all(24), child: Container()),
        );
      case UserPageVMItemType.add:
        return InkWell(
          child: Card(
            key: Key('Add'),
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
            key: Key('Remove'),
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