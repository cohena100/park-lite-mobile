import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/pages/car_page_vm.dart';

class CarPage extends StatefulWidget {
  CarPage({Key key}) : super(key: key);

  @override
  CarPageState createState() => CarPageState();
}

class CarPageState extends State<CarPage> {
  CarPageVM vm;
  static const textFieldMaxLength = 8;
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    vm = CarPageVM();
    vm.otherActionStream.listen((event) {
      CarPageVMOtherAction action = event;
      switch (action.state) {
        case CarPageVMOtherActionState.none:
          break;
        case CarPageVMOtherActionState.done:
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
          break;
      }
    });
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: CarPageVMAction(),
        builder: (context, snapshot) {
          CarPageVMAction action = snapshot.data;
          switch (action.state) {
            case CarPageVMActionState.none:
              return Container();
              break;
            case CarPageVMActionState.number:
              return car(context, action.data[CarPageVMActionDataKeys.number]);
              break;
          }
        });
  }

  Widget car(BuildContext context, String number) {
    _textEditingController.value =
        number == null ? TextEditingValue() : TextEditingValue(text: number);
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
            controller: _textEditingController,
            autofocus: true,
            keyboardType: isIOS ? TextInputType.text : TextInputType.number,
            maxLength: CarPageState.textFieldMaxLength,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).carNumberHint,
            ),
            onChanged: (String s) {
              vm.numberChanged(s);
            },
            onSubmitted: (String s) async {
              vm.numberSubmitted();
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
