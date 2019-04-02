import 'package:flutter/material.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/pages/home_page.dart';
import 'package:pango_lite/pages/main_page_vm.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/phone_page.dart';

class MainPage extends StatefulWidget {
  final Map vmPayload;

  MainPage({Key key, @required this.vmPayload}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  MainPageVM vm;

  @override
  Widget build(BuildContext context) {
    vm?.close();
    vm = model.mainPageVM(widget.vmPayload);
    return StreamBuilder(
      stream: vm.actionStream,
      initialData: MainPageVMActions.none,
      builder: (context, snapshot) {
        final MainPageVMActions action = snapshot.data;
        Widget title = Text(AppLocalizations.of(context).title);
        Widget child;
        switch (action) {
          case MainPageVMActions.none:
            vm.handshake();
            break;
          case MainPageVMActions.busy:
            child = CircularProgressIndicator();
            break;
          case MainPageVMActions.phone:
            child = PhonePage(key: Key('PhonePage'),vmPayload: {});
            break;
          case MainPageVMActions.home:
            child = HomePage(key: Key('HomePage'),vmPayload: {});
        }
        return Scaffold(
          appBar: AppBar(
            title: title,
          ),
          body: Center(
            child: child,
          ),
        );
      },
    );
  }
}
