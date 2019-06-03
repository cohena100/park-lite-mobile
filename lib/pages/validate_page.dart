import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/validate_page_vm.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class ValidatePage extends StatefulWidget {
  ValidatePage({Key key}) : super(key: WidgetKeys.validatePageKey);

  @override
  ValidatePageState createState() => ValidatePageState();
}

class ValidatePageState extends State<ValidatePage> {
  static const textFieldMaxLength = 4;
  ValidatePageVM vm = ValidatePageVM();
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
        initialData: ValidatePageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          switch (action.state) {
            case ValidatePageVMActionState.busy:
              return Center(child: CircularProgressIndicator());
            case ValidatePageVMActionState.validate:
              return nickname(
                  context, action.data[ValidatePageVMActionDataKey.code]);
            default:
              return Container();
          }
        });
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }

  @override
  void initState() {
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case ValidatePageVMOtherActionState.rootPage:
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.rootPage));
          break;
        default:
          break;
      }
      isDirty = true;
    });
    super.initState();
  }

  Widget nickname(BuildContext context, String code) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    _textEditingController.value =
        code == null ? TextEditingValue() : TextEditingValue(text: code);
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).validateTitle)),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                  key: WidgetKeys.validateTextFieldKey,
                  controller: _textEditingController,
                  autofocus: true,
                  keyboardType:
                      isIOS ? TextInputType.text : TextInputType.number,
                  maxLength: ValidatePageState.textFieldMaxLength,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).validateHint),
                  onChanged: (String s) {
                    vm.codeChanged(s);
                  },
                  onSubmitted: (String s) async {
                    vm.codeSubmitted();
                  })
            ]));
  }
}
