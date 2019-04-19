import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/verification_page_vm.dart';

class VerificationPage extends StatefulWidget {
  VerificationPage({Key key}) : super(key: Key('VerificationPage'));

  @override
  VerificationPageState createState() => VerificationPageState();
}

class VerificationPageState extends State<VerificationPage> {
  static const textFieldMaxLength = 4;
  VerificationPageVM vm;
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    vm = VerificationPageVM();
    vm.otherActionStream.listen((event) {
      VerificationPageVMOtherAction action = event;
      switch (action.state) {
        case VerificationPageVMOtherActionState.none:
          break;
        case VerificationPageVMOtherActionState.done:
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
          break;
      }
    });
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: VerificationPageVMAction(),
        builder: (context, snapshot) {
          VerificationPageVMAction action = snapshot.data;
          switch (action.state) {
            case VerificationPageVMActionState.none:
              return Container();
            case VerificationPageVMActionState.busy:
              return Center(
                child: CircularProgressIndicator(),
              );
            case VerificationPageVMActionState.verification:
              return nickname(context,
                  action.data[VerificationPageVMActionDataKeys.verification]);
          }
        });
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }

  Widget nickname(BuildContext context, String verification) {
    _textEditingController.value = verification == null
        ? TextEditingValue()
        : TextEditingValue(text: verification);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).verificationTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            key: Key('VerificationTextField'),
            controller: _textEditingController,
            autofocus: true,
            maxLength: VerificationPageState.textFieldMaxLength,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).verificationHint,
            ),
            onChanged: (String s) {
              vm.verificationChanged(s);
            },
            onSubmitted: (String s) async {
              vm.verificationSubmitted();
            },
          ),
        ],
      ),
    );
  }
}
