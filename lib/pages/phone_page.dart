import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/car_page.dart';
import 'package:pango_lite/pages/phone_page_vm.dart';

class PhonePage extends StatefulWidget {
  PhonePage({Key key}) : super(key: key);

  @override
  PhonePageState createState() => PhonePageState();
}

class PhonePageState extends State<PhonePage> {
  PhonePageVM vm;
  static const textFieldMaxLength = 10;
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    vm = PhonePageVM();
    vm.otherActionStream.listen((event) {
      PhonePageVMOtherAction action = event;
      switch (action.state) {
        case PhonePageVMOtherActionState.none:
          break;
        case PhonePageVMOtherActionState.done:
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarPage(key: Key('CarPage')),
              ));
          break;
      }
    });
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: PhonePageVMAction(),
        builder: (context, snapshot) {
          PhonePageVMAction action = snapshot.data;
          switch (action.state) {
            case PhonePageVMActionState.none:
              return Container();
              break;
            case PhonePageVMActionState.phone:
              return phone(
                  context, action.data[PhonePageVMActionDataKeys.phone]);
              break;
          }
        });
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

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }
}
