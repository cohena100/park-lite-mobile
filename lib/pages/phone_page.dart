import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/phone_page_vm.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class PhonePage extends StatefulWidget {
  PhonePage({Key key}) : super(key: WidgetKeys.phonePageKey);

  @override
  PhonePageState createState() => PhonePageState();
}

class PhonePageState extends State<PhonePage> {
  static const textFieldMaxLength = 10;
  PhonePageVM vm = PhonePageVM();
  final _textEditingController = TextEditingController();
  bool isDirty = true;

  @override
  Widget build(BuildContext context) {
    if (isDirty) {
      vm.init().then((_) {});
      isDirty = false;
    }
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: PhonePageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          switch (action.state) {
            case PhonePageVMActionState.phone:
              return phone(
                  context, action.data[PhonePageVMActionDataKey.phone]);
            case PhonePageVMActionState.busy:
              return Center(child: CircularProgressIndicator());
            default:
              return Container();
          }
        });
  }

  @override
  void dispose() {
    vm.close();
    super.dispose();
  }

  @override
  void initState() {
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case PhonePageVMOtherActionState.validatePage:
          Navigator.pushNamed(context, Routes.validatePage);
          break;
        default:
          break;
      }
      isDirty = true;
    });
    super.initState();
  }

  Widget phone(BuildContext context, String phone) {
    _textEditingController.value =
        phone == null ? TextEditingValue() : TextEditingValue(text: phone);
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
              key: WidgetKeys.phoneTextFieldKey,
              controller: _textEditingController,
              autofocus: true,
              keyboardType: isIOS ? TextInputType.text : TextInputType.number,
              maxLength: PhonePageState.textFieldMaxLength,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).phoneNumberHint),
              onChanged: (String s) {
                vm.phoneChanged(s);
              },
              onSubmitted: (String s) async {
                await vm.phoneSubmitted();
              })
        ]);
  }
}
