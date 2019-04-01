import 'package:flutter/material.dart';
import 'package:pango_lite/pages/home_page_vm.dart';

class HomePage extends StatefulWidget {
  final HomePageVM vm;

  HomePage({Key key, @required this.vm}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.vm.actionStream,
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

  @override
  void dispose() {
    widget.vm.close();
    super.dispose();
  }
}
