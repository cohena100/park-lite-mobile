import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/car_page_vm.dart';

class CarPage extends StatefulWidget {
  final CarPageVM vm;

  CarPage({Key key, @required this.vm}) : super(key: key);

  @override
  CarPageState createState() => CarPageState();
}

class CarPageState extends State<CarPage> {
  static const textFieldMaxLength = 8;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.vm.actionStream,
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
            onSubmitted: (String s) async {
              final result = await _login(s);
              print('avic: ' + result.toString());
            },
            onChanged: (String s) async {
              bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
              if (isIOS && s.length == CarPageState.textFieldMaxLength) {
                final result = await _login(s);
                print('avic: ' + result.toString());
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.vm.close();
    super.dispose();
  }

  Future _login(String car) {
    return widget.vm.login(widget.vm.phone, car);
  }
}
