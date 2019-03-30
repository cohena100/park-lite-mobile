import 'package:flutter/material.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/pages/main_page_vm.dart';
import 'package:pango_lite/locale/locale.dart';

class MainPage extends StatefulWidget {
  final MainPageVM vm;

  MainPage({Key key, @required this.vm}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    widget.vm.login();
    return StreamBuilder(
      stream: widget.vm.actionStream,
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
            child = model.phonePage();
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
    widget.vm.close();
    super.dispose();
  }
}
