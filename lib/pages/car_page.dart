import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/car_page_vm.dart';

class CarPage extends StatefulWidget {
  @override
  CarPageState createState() => CarPageState();
}

class CarPageState extends State<CarPage> {
  static const textFieldMaxLength = 8;
  final vm = CarPageVM();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: vm.actionStream,
        initialData: CarPageVMActions.none,
        builder: (context, snapshot) {
          CarPageVMActions action = snapshot.data;
          switch (action) {
            case CarPageVMActions.none:
              return car(context);
              break;
          }
        });
  }

  Widget car(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: CarPageState.textFieldMaxLength,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).carNumberHint,
            ),
            onSubmitted: (String s) {
              print(s);
            },
            onChanged: (String s) {
              bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
              if (isIOS && s.length == CarPageState.textFieldMaxLength) {
                print(s);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    vm.close();
    super.dispose();
  }
}
