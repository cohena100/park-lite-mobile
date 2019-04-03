import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/car_page.dart';
import 'package:pango_lite/pages/phone_page_vm.dart';
import 'package:pango_lite/model/model.dart';

class PhonePage extends StatefulWidget {
  final Map vmPayload;

  PhonePage({Key key, @required this.vmPayload}) : super(key: key);

  @override
  PhonePageState createState() => PhonePageState();
}

class PhonePageState extends State<PhonePage> {
  PhonePageVM vm;
  static const textFieldMaxLength = 10;

  @override
  Widget build(BuildContext context) {
    vm = model.phonePageVM(widget.vmPayload);
    return StreamBuilder(
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
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          key: Key('PhoneTextField'),
          autofocus: true,
          keyboardType: isIOS ? TextInputType.text : TextInputType.number,
          maxLength: PhonePageState.textFieldMaxLength,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).phoneNumberHint,
          ),
          onSubmitted: (String s) {
            navigateToCar(context, s);
          },
        ),
      ],
    );
  }

  void navigateToCar(BuildContext context, String phone) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarPage(key: Key('CarPage'),vmPayload: {'phone': phone}),
        ));
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }
}
