import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class ValidatePageVM {
  BehaviorSubject _actionSubject;
  final _otherActionSubject = BehaviorSubject();
  ValidatePageVM() {
    String code = model.accountBloc.code;
    _actionSubject = BehaviorSubject(
        seedValue: ValidatePageVMAction(
            data: {ValidatePageVMActionDataKey.validate: code},
            state: ValidatePageVMActionState.validate));
  }
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  void validateChanged(String s) {
    model.accountBloc.code = s;
  }

  Future validateSubmitted() async {
    _actionSubject
        .add(ValidatePageVMAction(state: ValidatePageVMActionState.busy));
    final state = await model.accountBloc.validate() as AccountBlocState;
    switch (state) {
      case AccountBlocState.loggedIn:
        _otherActionSubject.add(ValidatePageVMOtherAction(
            state: ValidatePageVMOtherActionState.homePage));
        break;
      default:
        break;
    }
  }
}

class ValidatePageVMAction {
  final Map data;
  final ValidatePageVMActionState state;
  ValidatePageVMAction(
      {this.data = const {}, this.state = ValidatePageVMActionState.none});
}

enum ValidatePageVMActionDataKey { none, validate }

enum ValidatePageVMActionState { none, busy, validate }

class ValidatePageVMOtherAction {
  final Map data;
  final ValidatePageVMOtherActionState state;
  ValidatePageVMOtherAction(
      {this.data = const {}, this.state = ValidatePageVMOtherActionState.none});
}

enum ValidatePageVMOtherActionDataKey { none }

enum ValidatePageVMOtherActionState { none, homePage }
