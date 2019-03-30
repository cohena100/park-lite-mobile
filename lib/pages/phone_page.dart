import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/phone_page_vm.dart';
import 'package:pango_lite/model/model.dart';

class PhonePage extends StatefulWidget {
  final PhonePageVM vm;

  PhonePage({Key key, @required this.vm}) : super(key: key);

  @override
  PhonePageState createState() => PhonePageState();
}

class PhonePageState extends State<PhonePage> {
  static const textFieldMaxLength = 10;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.vm.actionStream,
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
            navigateToCar(context, s);
          },
          onChanged: (String s) {
            bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
            if (isIOS && s.length == PhonePageState.textFieldMaxLength) {
              navigateToCar(context, s);
            }
          },
        ),
      ],
    );
  }

  void navigateToCar(BuildContext context, String phone) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => model.carPage(phone),
        ));
  }

  @override
  void dispose() {
    widget.vm.close();
    super.dispose();
  }
}
