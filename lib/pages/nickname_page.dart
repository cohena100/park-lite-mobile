import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/nickname_page_vm.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class NicknamePage extends StatefulWidget {
  NicknamePage({Key key}) : super(key: WidgetKeys.nicknamePageKey);

  @override
  NicknamePageState createState() => NicknamePageState();
}

class NicknamePageState extends State<NicknamePage> {
  static const textFieldMaxLength = 20;
  NicknamePageVM vm = NicknamePageVM();
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
        initialData: NicknamePageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          Widget body;
          switch (action.state) {
            case NicknamePageVMActionState.busy:
              body = Center(child: CircularProgressIndicator());
              break;
            case NicknamePageVMActionState.nickname:
              body = nickname(
                  context, action.data[NicknamePageVMActionDataKey.nickname]);
              break;
            default:
              body = Container();
              break;
          }
          return Scaffold(
            appBar: AppBar(
                title: Text(AppLocalizations.of(context).carNicknameTitle)),
            body: body,
          );
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
        case NicknamePageVMOtherActionState.validatePage:
          Navigator.pushNamed(context, Routes.validatePage);
          break;
        case NicknamePageVMOtherActionState.rootPage:
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.rootPage));
          break;
        default:
          break;
      }
      isDirty = true;
    });
    super.initState();
  }

  Widget nickname(BuildContext context, String number) {
    _textEditingController.value =
        number == null ? TextEditingValue() : TextEditingValue(text: number);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
              key: WidgetKeys.nicknameTextFieldKey,
              controller: _textEditingController,
              autofocus: true,
              maxLength: NicknamePageState.textFieldMaxLength,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).carNicknameHint),
              onChanged: (String s) {
                vm.nicknameChanged(s);
              },
              onSubmitted: (String s) async {
                await vm.nicknameSubmitted();
              })
        ]);
  }
}
