import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/nickname_page_vm.dart';

class NicknamePage extends StatefulWidget {
  NicknamePage({Key key}) : super(key: Key('NicknamePage'));

  @override
  NicknamePageState createState() => NicknamePageState();
}

class NicknamePageState extends State<NicknamePage> {
  static const textFieldMaxLength = 20;
  NicknamePageVM vm;
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    vm = NicknamePageVM();
    vm.otherActionStream.listen((event) {
      NicknamePageVMOtherAction action = event;
      switch (action.state) {
        case NicknamePageVMOtherActionState.none:
          break;
        case NicknamePageVMOtherActionState.homePage:
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
          break;
        case NicknamePageVMOtherActionState.validatePage:
          Navigator.pushNamed(context, '/validate');
          break;
      }
    });
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: NicknamePageVMAction(),
        builder: (context, snapshot) {
          NicknamePageVMAction action = snapshot.data;
          switch (action.state) {
            case NicknamePageVMActionState.none:
              return Container();
            case NicknamePageVMActionState.busy:
              return Center(
                child: CircularProgressIndicator(),
              );
            case NicknamePageVMActionState.nickname:
              return nickname(
                  context, action.data[NicknamePageVMActionDataKey.nickname]);
          }
        });
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }

  Widget nickname(BuildContext context, String number) {
    _textEditingController.value =
        number == null ? TextEditingValue() : TextEditingValue(text: number);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).carNicknameTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            key: Key('NicknameTextField'),
            controller: _textEditingController,
            autofocus: true,
            maxLength: NicknamePageState.textFieldMaxLength,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).carNicknameHint,
            ),
            onChanged: (String s) {
              vm.nicknameChanged(s);
            },
            onSubmitted: (String s) async {
              vm.nicknameSubmitted();
            },
          ),
        ],
      ),
    );
  }
}
