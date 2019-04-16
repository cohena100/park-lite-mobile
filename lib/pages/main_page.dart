import 'package:flutter/material.dart';
import 'package:pango_lite/pages/home_page.dart';
import 'package:pango_lite/pages/main_page_vm.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/phone_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  MainPageVM vm;

  @override
  Widget build(BuildContext context) {
    vm = MainPageVM();
    return StreamBuilder(
      stream: vm.actionStream,
      initialData: MainPageVMAction(),
      builder: (context, snapshot) {
        final MainPageVMAction action = snapshot.data;
        Widget title = Text(AppLocalizations.of(context).title);
        Widget child;
        switch (action.state) {
          case MainPageVMActionState.none:
            child = Container();
            break;
          case MainPageVMActionState.phone:
            child = PhonePage();
            title = Text(AppLocalizations.of(context).phoneNumberTitle);
            break;
          case MainPageVMActionState.home:
            child = HomePage();
            break;
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

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }
}
