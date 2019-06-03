import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/home_page.dart';
import 'package:pango_lite/pages/main_page_vm.dart';
import 'package:pango_lite/pages/phone_page.dart';
import 'package:pango_lite/pages/user_page.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  MainPageVM vm = MainPageVM();

  @override
  Widget build(BuildContext context) {
    vm.init().then((_) {});
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: MainPageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          Widget title = Text(AppLocalizations.of(context).title);
          Widget child;
          switch (action.state) {
            case MainPageVMActionState.phonePage:
              title = Text(AppLocalizations.of(context).phoneNumberTitle);
              child = PhonePage();
              break;
            case MainPageVMActionState.homePage:
              return DefaultTabController(
                  length: 2,
                  child: Scaffold(
                      appBar: AppBar(
                        bottom: TabBar(tabs: [
                          Tab(
                              key: WidgetKeys.parkTabKey,
                              icon: Icon(Icons.directions_car)),
                          Tab(
                              key: WidgetKeys.userTabKey,
                              icon: Icon(Icons.account_circle))
                        ]),
                        title: title,
                      ),
                      body: TabBarView(children: [HomePage(), UserPage()])));
            default:
              child = Container();
          }
          return Scaffold(
              appBar: AppBar(title: title), body: Center(child: child));
        });
  }

  @override
  void dispose() {
    vm.close();
    super.dispose();
  }
}
