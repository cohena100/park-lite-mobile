import 'package:flutter/material.dart';
import 'package:pango_lite/pages/home_page_vm.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: Key('HomePage'));

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HomePageVM vm;

  @override
  Widget build(BuildContext context) {
    vm = HomePageVM();
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: HomePageVMAction(),
        builder: (context, snapshot) {
          HomePageVMAction action = snapshot.data;
          switch (action.state) {
            case HomePageVMActionState.none:
              vm.init();
              return Container();
            case HomePageVMActionState.home:
              return Center(child: Text('Home Page'));
          }
        });
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }
}
