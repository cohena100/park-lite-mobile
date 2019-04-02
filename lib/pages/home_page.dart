import 'package:flutter/material.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/pages/home_page_vm.dart';

class HomePage extends StatefulWidget {
  final Map vmPayload;

  HomePage({Key key, @required this.vmPayload}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HomePageVM vm;

  @override
  Widget build(BuildContext context) {
    vm?.close();
    vm = model.homePageVM(widget.vmPayload);
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: HomePageVMActions.none,
        builder: (context, snapshot) {
          HomePageVMActions action = snapshot.data;
          switch (action) {
            case HomePageVMActions.none:
              return Center(child: Text('Home Page'));
              break;
          }
        });
  }
}
