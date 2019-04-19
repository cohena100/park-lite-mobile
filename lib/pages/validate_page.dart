import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/pages/validate_page_vm.dart';

class ValidatePage extends StatefulWidget {
  ValidatePage({Key key}) : super(key: Key('ValidatePage'));

  @override
  ValidatePageState createState() => ValidatePageState();
}

class ValidatePageState extends State<ValidatePage> {
  static const textFieldMaxLength = 4;
  ValidatePageVM vm;
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    vm = ValidatePageVM();
    vm.otherActionStream.listen((event) {
      ValidatePageVMOtherAction action = event;
      switch (action.state) {
        case ValidatePageVMOtherActionState.none:
          break;
        case ValidatePageVMOtherActionState.done:
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
          break;
      }
    });
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: ValidatePageVMAction(),
        builder: (context, snapshot) {
          ValidatePageVMAction action = snapshot.data;
          switch (action.state) {
            case ValidatePageVMActionState.none:
              return Container();
            case ValidatePageVMActionState.busy:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ValidatePageVMActionState.validate:
              return nickname(context,
                  action.data[ValidatePageVMActionDataKey.validate]);
          }
        });
  }

  @override
  void dispose() {
    vm?.close();
    super.dispose();
  }

  Widget nickname(BuildContext context, String code) {
    _textEditingController.value = code == null
        ? TextEditingValue()
        : TextEditingValue(text: code);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).validateTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            key: Key('ValidateTextField'),
            controller: _textEditingController,
            autofocus: true,
            maxLength: ValidatePageState.textFieldMaxLength,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).validateHint,
            ),
            onChanged: (String s) {
              vm.validateChanged(s);
            },
            onSubmitted: (String s) async {
              vm.validateSubmitted();
            },
          ),
        ],
      ),
    );
  }
}