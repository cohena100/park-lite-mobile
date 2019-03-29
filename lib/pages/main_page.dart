import 'package:flutter/material.dart';
import 'package:pango_lite/pages/main_page_vm.dart';
import 'package:pango_lite/pages/phone_page.dart';
import 'package:pango_lite/locale/locale.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final MainPageVM vm = MainPageVM();

  @override
  Widget build(BuildContext context) {
    vm.login();
    return StreamBuilder(
      stream: vm.actionStream,
      initialData: MainPageVMActions.busy,
      builder: (context, snapshot) {
        final MainPageVMActions action = snapshot.data;
        Widget title = Text(AppLocalizations.of(context).title);
        Widget child;
        switch (action) {
          case MainPageVMActions.busy:
            child = CircularProgressIndicator();
            break;
          case MainPageVMActions.phone:
            child = PhonePage();
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
    vm.close();
    super.dispose();
  }
}
