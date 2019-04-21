import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/phone_page_vm.dart';
import 'package:pango_lite/pages/routes.dart';

class PhonePage extends StatefulWidget {
  PhonePage({Key key}) : super(key: Key('PhonePage'));

  @override
  PhonePageState createState() => PhonePageState();
}

class PhonePageState extends State<PhonePage> {
  static const textFieldMaxLength = 10;
  PhonePageVM vm;
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    vm = PhonePageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case PhonePageVMOtherActionState.none:
          break;
        case PhonePageVMOtherActionState.carPage:
          Navigator.pushNamed(context, Routes.carPage);
          break;
      }
    });
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: PhonePageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          switch (action.state) {
            case PhonePageVMActionState.none:
              return Container();
            case PhonePageVMActionState.phone:
              return phone(
                  context, action.data[PhonePageVMActionDataKey.phone]);
          }
        });
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
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
          key: Key('PhoneTextField'),
          controller: _textEditingController,
          autofocus: true,
          keyboardType: isIOS ? TextInputType.text : TextInputType.number,
          maxLength: PhonePageState.textFieldMaxLength,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).phoneNumberHint,
          ),
          onChanged: (String s) {
            vm.phoneChanged(s);
          },
          onSubmitted: (String s) {
            vm.phoneSubmitted();
          },
        ),
      ],
    );
  }
}
