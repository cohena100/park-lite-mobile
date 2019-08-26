import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/car_page_vm.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class CarPage extends StatefulWidget {
  CarPage({Key key}) : super(key: WidgetKeys.carPageKey);

  @override
  CarPageState createState() => CarPageState();
}

class CarPageState extends State<CarPage> {
  static const textFieldMaxLength = 8;
  CarPageVM vm;
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(AppLocalizations.of(context).carNumberTitle)),
        body: StreamBuilder(
            stream: vm.actionStream,
            initialData: CarPageVMAction(),
            builder: (context, snapshot) {
              final action = snapshot.data;
              switch (action.state) {
                case CarPageVMActionState.number:
                  return car(
                      context, action.data[CarPageVMActionDataKey.number]);
                default:
                  return Container();
              }
            }));
  }

  Widget car(BuildContext context, String number) {
    _textEditingController.value =
        number == null ? TextEditingValue() : TextEditingValue(text: number);
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
              key: WidgetKeys.carTextFieldKey,
              controller: _textEditingController,
              autofocus: true,
              keyboardType: isIOS ? TextInputType.text : TextInputType.number,
              maxLength: CarPageState.textFieldMaxLength,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).carNumberHint),
              onChanged: (String s) {
                vm.numberChanged(s);
              },
              onSubmitted: (String s) async {
                vm.numberSubmitted();
              })
        ]);
  }

  @override
  void dispose() {
    vm.close();
    super.dispose();
  }

  @override
  void initState() {
    vm = CarPageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case CarPageVMOtherActionState.nicknamePage:
          Navigator.pushNamed(context, Routes.nicknamePage);
          break;
        default:
          break;
      }
    });
    super.initState();
  }
}
