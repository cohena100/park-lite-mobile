import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/phone_page_vm.dart';

class PhonePage extends StatefulWidget {
  @override
  PhonePageState createState() => PhonePageState();
}

class PhonePageState extends State<PhonePage> {
  static const textFieldMaxLength = 10;
  final vm = PhonePageVM();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: vm.actionStream,
        initialData: PhonePageVMActions.none,
        builder: (context, snapshot) {
          PhonePageVMActions action = snapshot.data;
          switch (action) {
            case PhonePageVMActions.none:
              return phone(context);
              break;
          }
        });
  }

  Widget phone(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          maxLength: PhonePageState.textFieldMaxLength,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).phoneNumberHint,
          ),
          onSubmitted: (String s) {
            print(s);
          },
          onChanged: (String s) {
            bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
            if (isIOS && s.length == PhonePageState.textFieldMaxLength) {
              print(s);
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    vm.close();
    super.dispose();
  }
}
