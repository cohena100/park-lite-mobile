import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/pages/car_page_vm.dart';

class CarPage extends StatefulWidget {
  final Map vmPayload;

  CarPage({Key key, @required this.vmPayload}) : super(key: key);

  @override
  CarPageState createState() => CarPageState();
}

class CarPageState extends State<CarPage> {
  CarPageVM vm;
  static const textFieldMaxLength = 8;

  @override
  Widget build(BuildContext context) {
    vm = model.carPageVM(widget.vmPayload);
    return StreamBuilder(
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
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            key: Key('CarTextField'),
            autofocus: true,
            keyboardType: isIOS ? TextInputType.text : TextInputType.number,
            maxLength: CarPageState.textFieldMaxLength,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).carNumberHint,
            ),
            onSubmitted: (String s) async {
              print(await vm.login(s));
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }
}
